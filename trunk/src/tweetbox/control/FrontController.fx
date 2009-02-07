/*
 * FrontController.fx
 *
 * Created on 7-nov-2008, 23:26:27
 */

package tweetbox.control;

import tweetbox.model.*;
import tweetbox.valueobject.*;
import java.lang.System;
import java.util.Calendar;
import java.util.List;
import java.util.Vector;
import java.util.Date;
import java.util.ConcurrentModificationException;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.io.ObjectOutputStream;
import java.io.ObjectInputStream;
import java.io.File;
import java.io.IOException;

import javafx.animation.*;
import javafx.geometry.Point2D;

import twitter4j.Twitter;
import twitter4j.TwitterAdapter;
import twitter4j.TwitterListener;
import twitter4j.Status;
import twitter4j.User;
import twitter4j.DirectMessage;
import twitter4j.TwitterException;
import twitter4j.TwitterResponse;

import tweetbox.twitter.TwitterHelper;
import tweetbox.command.*;

import org.jfxtras.async.JFXWorker;

/**
 * The main (front) controller of this application.
 * It provides a centralized entry point for handling requests to external services and handling the responses
 * This class  is a singleton (only a single instance is allowed)
 * @author mnankman
 */
public class FrontController {

 /*
  * --------------------------------------------------------------------------
  * private class variables
  * --------------------------------------------------------------------------
  */

    var model = Model.getInstance();
    var twitter:Twitter = new Twitter();

    /** the command responsible for getting the friends timeline */
    var getFriendsTimelineCommand = GetFriendsTimelineCommand {
        twitter: twitter
        onDone: processReceivedTwitterResponse
        onFailure: processFailure
        group: model.friendUpdates
    };

    /** the command responsible for getting replies */
    var getRepliesCommand = GetRepliesCommand {
        twitter: twitter
        onDone: processReceivedTwitterResponse
        onFailure: processFailure
        group: model.replies
    };

    /** the command responsible for getting direct messages */
    var getDirectMessagesCommand = GetDirectMessagesCommand {
        twitter: twitter
        onDone: processReceivedTwitterResponse
        onFailure: processFailure
        group: model.directMessages
    };

    /** the command responsible for getting the user timeline */
    var getUserTimelineCommand = GetUserTimelineCommand {
        twitter: twitter
        onDone: processReceivedTwitterResponse
        onFailure: processFailure
        group: model.userUpdates
    };

    /** the command responsible for getting the favorites */
    var getFavoritesCommand = GetFavoritesCommand {
        twitter: twitter
        onDone: processReceivedTwitterResponse
        onFailure: processFailure
        group: model.favorites
    };

    /** the timeline for scheduling the retreival of the friends timeline */
    var getFriendsTimelineTimeline:Timeline = Timeline {
        keyFrames: [
            KeyFrame {
                time: 1ms
                action: function() {
                    getFriendsTimelineCommand.run();
                }
            },
            KeyFrame {
                time: bind model.config.twitterAPISettings.getFriendTimelineInterval
                action: function() {}
            }

        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    /** the timeline for scheduling the retreival of the user timeline */
    var getUserTimelineTimeline:Timeline = Timeline {
        keyFrames: [
            KeyFrame {
                time: 1ms
                action: function() {
                    getUserTimelineCommand.run();
                }
            },
            KeyFrame {
                time: bind model.config.twitterAPISettings.getUserTimelineInterval
                action: function() {}
            }

        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    /** the timeline for scheduling the retreival of the replies */
    var getRepliesTimeline:Timeline = Timeline {
        keyFrames: [
            KeyFrame {
                time: 1ms
                action: function() {
                    getRepliesCommand.run();
                }
            },
            KeyFrame {
                time: bind model.config.twitterAPISettings.getRepliesInterval
                action: function() {}
            }

        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    /** the timeline for scheduling the retreival of the direct messages */
    var getDirectMessagesTimeline = Timeline {
        keyFrames: [
            KeyFrame {
                time: 1ms
                action: function() {
                    getDirectMessagesCommand.run();
                }
            },
            KeyFrame {
                time: bind model.config.twitterAPISettings.getDirectMessagesInterval
                action: function() {}
            }

        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

 /*
  * --------------------------------------------------------------------------
  * public class functions
  * --------------------------------------------------------------------------
  */

    /**
     * Initializes the connectioon with the Twitter API and starts the
     * timelines that periodically get new updates for the various groups
     */
    public function start(stage:javafx.stage.Stage) {
        twitter.setSource("tweetbox");

        model.config.applicationStage = stage;

        loadConfig();
        //loadFromCache();

        if (isAccountConfigured("twitter")) {
            var twitterAccount = getAccount("twitter");
            twitter.setUserId(twitterAccount.login);
            twitter.setPassword(twitterAccount.password);
        } else {
            model.configDialogVisible = true;
        }

        model.friendUpdates.refresh = getFriendsTimelineCommand.run;
        model.replies.refresh = getRepliesCommand.run;
        model.directMessages.refresh = getDirectMessagesCommand.run;
        model.userUpdates.refresh = getUserTimelineCommand.run;
        model.favorites.refresh = getFavoritesCommand.run;

        startReceiving();
    }

    /**
     * Stops all timelines, saves the configuration and exits the application
     */
    public function exit() {
        model.state = State.EXITING;
        stopReceiving();
        saveConfig();
        //saveToCache();
        System.exit(0);
    }

    /**
     * Sends an update
     * @param update - a String containing the text of the update
     */
    public function sendUpdate(update:String) {
        try {
            if (model.directMessageMode) {
                sendDirectMessage(update);
            }
            else {
                var result:Object = null;
                result = twitter.update(update);
                updated(result as Status);
            }
        }
        catch (e:TwitterException) {
            stopReceiving();
            model.updateText = "";
            model.updateNodeVisible = false;
            println("twitter exception: {e}");
        }
    }
    
    public function search(query:String) {
    }

    public function cancelUpdate():Void {
        model.updateNodeVisible = false;
        model.updateText = ""
    }
    
    public function reply(user:UserVO, pos:Point2D) {
        model.updateNodeVisible = true;
        model.updateNodePosition = pos;
        model.directMessageMode = false;
        model.updateText = "{model.updateText}@{user.screenName} "
    }

    public function reply(tweet:TweetVO, pos:Point2D) {
        model.updateNodeVisible = true;
        model.updateNodePosition = pos;
        model.directMessageMode = false;
        model.updateText = "{model.updateText}@{tweet.user.screenName} "
    }

    public function direct(user:UserVO, pos:Point2D) {
        model.updateNodeVisible = true;
        model.updateNodePosition = pos;
        model.directMessageMode = true;
        model.directMessageReceiver = user;
        model.updateText = "" 
    }
    
    public function retweet(tweet:TweetVO, pos:Point2D) {
        model.updateNodeVisible = true;
        model.updateNodePosition = pos;
        model.directMessageMode = false;
        model.updateText = "RT @{tweet.user.screenName}: {tweet.text}"
    }
    
    public function follow(user:String) {
        
    }
    
    public function updateAccount(updatedAccount:AccountVO) {
        stopReceiving();
        model.config.updateAccount(updatedAccount);
        twitter.setUserId(updatedAccount.login);
        twitter.setPassword(updatedAccount.password);
        saveConfig();
        startReceiving();
    }

    public function addAccount(newAccount:AccountVO) {
        model.config.addAccount(newAccount);
    }
    
    public function getAccount(id:String) {
        return model.config.getAccount(id);
    }

    public function isAccountConfigured(id:String) {
        return (getAccount(id) != null and getAccount(id).login.trim() != "");
    }
    
    public function saveConfig() {
        model.config.save();
    }
    
    public function loadConfig() {
        model.config.load();
    }

    public function addAlertMessage(message:String): Void {
        if (model.alertMessages != null and sizeof model.alertMessages > 0) 
            insert message into model.alertMessages
        else
            model.alertMessages = [message];
        model.alertMessageCount++;
    }

    public function clearAlertMessages(): Void {
        if (model.alertMessages != null and sizeof model.alertMessages > 0) {
            delete model.alertMessages;
            model.alertMessageCount = 0;
        }
    }

    public function showConfigDialog(): Void {
        model.configDialogVisible = true;
    }

    public function hideConfigDialog(): Void {
        model.configDialogVisible = false;
    }

    public function showAboutDialog(): Void {
        model.aboutDialogVisible = true;
    }

    public function hideAboutDialog(): Void {
        model.aboutDialogVisible = false;
    }

    /*
    public function loadFromCache() {
        var cacheFile = new File("{System.getProperty("user.home")}/tweetbox.cache");
        System.out.println("loading cache from: {cacheFile.getPath()}");
        var cache:Vector = new Vector();
        try {
            var input:ObjectInputStream = new ObjectInputStream(new FileInputStream(cacheFile));
            cache = input.readObject() as Vector;
            
            model.friendUpdates = cache.get(0) as Vector;
            model.newFriendUpdates = model.friendUpdates.size();
            
            model.replies = cache.get(1) as Vector;
            model.newReplies = model.replies.size();
            
            model.userUpdates = cache.get(2) as Vector;
            model.newUserUpdates = model.userUpdates.size();
            
            model.directMessages = cache.get(3) as Vector;
            model.newDirectMessages = model.directMessages.size();
            
            System.out.println("cache loaded from: {cacheFile.getPath()}");
        }
        catch (e:IOException) {
            System.out.println("could not read from cache. Cause: {e}");
        }
    }
    
    public function saveToCache() {
        var cacheFile = new File("{System.getProperty("user.home")}/tweetbox.cache");
        System.out.println("saving cache to: {cacheFile.getPath()}");
        var cache:Vector = new Vector();
        cache.add(model.friendUpdates);
        cache.add(model.replies);
        cache.add(model.userUpdates);
        cache.add(model.directMessages);
        try {
            var output:ObjectOutputStream = new ObjectOutputStream(new FileOutputStream(cacheFile));
            output.writeObject(cache);
            System.out.println("cache saved to: {cacheFile.getPath()}");
        }
        catch (e:IOException) {
            System.out.println("could not save cache. Cause: {e}");
        }
    }
    */

 /*
  * --------------------------------------------------------------------------
  * private class functions
  * --------------------------------------------------------------------------
  */

    function sendDirectMessage(update:String) {
        println("sending direct message [{update}] to [{model.directMessageReceiver.screenName}]");
        try {
            var result:Object = null;
            result = model.directMessageReceiver.user.sendDirectMessage(update);
            sentDirectMessage(result as DirectMessage);
        }
        catch (e:TwitterException) {
            stopReceiving();
            model.updateText = "";
            model.updateNodeVisible = false;
            println("twitter exception: {e}");
        }
    }

    function processFailure(error:Object) {
        println(error);
    }

    function processReceivedTwitterResponse(response:Object): Void {
        println("processReceivedTwitterResponse({response})");
        if (response instanceof TwitterResponseVO) {
            var tr = response as TwitterResponseVO;
            processReceivedUpdates(tr.result as List, tr.group);
        }
    }

    function processReceivedUpdates(updates:List, group:GroupVO): Void {
        if (updates != null) {
            println("processReceivedUpdates({updates.size()} updates, {group.id})");
            var newUpdates:List = new Vector();
            for (i:Integer in [0..updates.size()-1]) {
                var r:TwitterResponse = updates.get(i) as TwitterResponse;
                if (not group.updates.contains(r)) {
                    newUpdates.add(r);
                }
            }
            if (group.showAlerts and group.updates.size() > 0 and newUpdates.size() > 0) {
                addAlertMessage("{newUpdates.size()} new updates in {group.title}");
            }
            group.updates.addAll(0, newUpdates);
            group.newUpdates = newUpdates.size();
        }
        else {
            println("processReceivedUpdates(null, {group.id})");
        }
    }

    function updated(status:Status) {
        System.out.println("update was successfully sent");
        model.userUpdates.updates.add(0, status);
        model.userUpdates.newUpdates = 1;
        model.friendUpdates.updates.add(0, status);
        model.friendUpdates.newUpdates = 1;
        model.updateText = "";
        model.state = State.READY;
        model.updateNodeVisible = false;
        //addAlertMessage("update was sent succesfully");
    }

    function sentDirectMessage(message:DirectMessage) {
        System.out.println("direct message was successfully sent");
        model.directMessages.updates.add(0, message);
        model.directMessages.newUpdates = 1;
        model.updateText = "";
        model.state = State.READY;
        model.updateNodeVisible = false;
        //addAlertMessage("direct message was sent succesfully");
    }

    function startReceiving(): Void {
        if (isAccountConfigured("twitter")) {
            getFriendsTimelineTimeline.play();
            getUserTimelineTimeline.play();
            getRepliesTimeline.play();
            getDirectMessagesTimeline.play();

            getFavoritesCommand.run();
        }
    }

    function stopReceiving(): Void {
        getFriendsTimelineTimeline.stop();
        getUserTimelineTimeline.stop();
        getRepliesTimeline.stop();
        getDirectMessagesTimeline.stop();
    }

}

//-----------------Use Singleton pattern to get frontcontroller instance -----------------------
var instance:FrontController;

public function getInstance():FrontController {
    if (instance == null) {
        instance = FrontController {};
    }
    else {
        instance;
    }
}