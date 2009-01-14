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

import twitter4j.Twitter;
import twitter4j.TwitterAdapter;
import twitter4j.TwitterListener;
import twitter4j.Status;
import twitter4j.DirectMessage;
import twitter4j.TwitterException;

import org.jfxtras.async.JFXWorker;
/**
 * @author mnankman
 */

public class FrontController {
    var model = Model.getInstance();
    
    var since:Calendar = Calendar.getInstance();
    
    var twitter:Twitter;

    public function start() {
        loadConfig();
        //loadFromCache();
        var twitterAccount = getAccount("twitter");
        twitter = new Twitter(twitterAccount.login, twitterAccount.password);
        twitter.setSource("TweetBox");
        
        startReceiving();
    }
    
    public function exit() {
        model.state = State.EXITING;
        stopReceiving();
        saveConfig();
        //saveToCache();
        System.exit(0);
    }
    
    public function getFriendsTimelineInBackground():Void {
        var worker:JFXWorker = JFXWorker {
            inBackground: getFriendsTimeline
            onDone: function(result): Void {
                processReceivedStatuses(result as List, model.friendUpdates);
            }
        }
    }

    public function getFriendsTimeline(): Object {
        var result:Object = null;
        System.out.println("get friends timeline");
        result = twitter.getFriendsTimeline(getSinceDate(model.friendUpdates.updates));
        return result;
    }

    public function getUserTimelineInBackground():Void {
        var worker:JFXWorker = JFXWorker {
            inBackground: getUserTimeline
            onDone: function(result): Void {
                processReceivedStatuses(result as List, model.userUpdates);
            }
        }
    }

    public function getUserTimeline() {
        var result:Object = null;
        System.out.println("get user timeline");
        result = twitter.getUserTimeline();
        return result;
    }

    public function getRepliesInBackground():Void {
        var worker:JFXWorker = JFXWorker {
            inBackground: getReplies
            onDone: function(result): Void {
                processReceivedStatuses(result as List, model.replies);
            }
        }
    }

    public function getReplies() {
        var result:Object = null;
        System.out.println("get replies");
        result = twitter.getReplies();
        return result;
    }

    public function getDirectMessagesInBackground():Void {
        var worker:JFXWorker = JFXWorker {
            inBackground: getDirectMessages
            onDone: function(result): Void {
                processReceivedDirectMessages(result as List, model.directMessages);
            }
        }
    }

    public function getDirectMessages() {
        var result:Object = null;
        System.out.println("get direct messages");
        //result = twitter.getDirectMessages(getSinceDate(model.directMessages.updates));
        result = twitter.getDirectMessages();
        return result;
    }
    
    public function sendUpdate(update:String) {
        var result:Object = null;
        var twitterAccount = getAccount("twitter");
        result = twitter.update(update);
        return result;
    }
    
    function processReceivedStatuses(statuses:List, group:GroupVO) {
        if (statuses != null) {
            System.out.println("processReceivedStatuses({statuses.size()} statuses, {group.id})");
            var temp:List = new Vector();
            for (i:Integer in [0..statuses.size()-1]) {
                var s:Status = statuses.get(i) as Status;
                if (not group.updates.contains(s)) {
                    temp.add(s);
                }
            }
            group.updates.addAll(0, temp);
            group.newUpdates = statuses.size();
            model.state = State.READY;
            System.out.println("group[{group.id}].newUpdates = {group.newUpdates}");
        }
        else {
            System.out.println("processReceivedStatuses(null, {group.id})");
        }
    }

    function processReceivedDirectMessages(dms:List, group:GroupVO) {
        if (dms != null) {
            System.out.println("processReceivedStatuses({dms.size()} statuses, {group.id})");
            var temp:List = new Vector();
            for (i:Integer in [0..dms.size()-1]) {
                var dm:DirectMessage = dms.get(i) as DirectMessage;
                if (not group.updates.contains(dm)) {
                    temp.add(dm);
                }
            }
            group.updates.addAll(0, temp);
            group.newUpdates = dms.size();
            model.state = State.READY;
            System.out.println("group[{group.id}].newUpdates = {group.newUpdates}");
        }
        else {
            System.out.println("processReceivedStatuses(null, {group.id})");
        }
    }

    function updated(status:Status) {
        System.out.println("update was successfully sent");
        model.userUpdates.updates.add(0, status);
        model.userUpdates.newUpdates = 1;
        model.updateText = "";
        model.state = State.READY;
    }

    function sentDirectMessage(message:DirectMessage) {
        System.out.println("direct message was successfully sent");
        model.directMessages.updates.add(0, message);
        model.directMessages.newUpdates = 1;
        model.updateText = "";
        model.state = State.READY;
    }

    function getSinceDate(statuses:List): Date {
        var cal:Calendar = Calendar.getInstance();
        if (statuses != null and statuses.size() > 0) {
            var status:Status = statuses.get(0) as Status;
            cal.setTime(status.getCreatedAt());
        }
        else {
            cal.add(Calendar.HOUR_OF_DAY, -24);
        }
        return cal.getTime();
    }

    public function search(query:String) {
    }
    
    public function reply(to:String) {
        model.updateText = "{model.updateText}@{to} " 
    }
    
    public function direct(to:String) {
        model.updateText = "d {to} " 
    }
    
    public function retweet(user:String, text:String) {
        model.updateText = "RT @{user}: {text}" 
    }
    
    public function follow(user:String) {
        
    }
    
    public function updateAccount(updatedAccount:AccountVO) {
        model.config.updateAccount(updatedAccount);
    }

    public function addAccount(newAccount:AccountVO) {
        model.config.addAccount(newAccount);
    }
    
    public function getAccount(id:String) {
        return model.config.getAccount(id);
    }
    
    public function saveConfig() {
        model.config.save();
    }
    
    public function loadConfig() {
        model.config.load();
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
    var getFriendsTimelineTimeline = Timeline {
        keyFrames: [
            KeyFrame { 
                time: 1ms 
                action: function() { 
                    getFriendsTimelineInBackground();
                }
            },
            KeyFrame { 
                time: bind model.config.twitterAPISettings.getFriendTimelineInterval 
                action: function() {}
            }
            
        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    var getUserTimelineTimeline = Timeline {
        keyFrames: [
            KeyFrame { 
                time: 1ms 
                action: function() { 
                    getUserTimelineInBackground();
                }
            },
            KeyFrame { 
                time: bind model.config.twitterAPISettings.getUserTimelineInterval 
                action: function() {}
            }
            
        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    var getRepliesTimeline = Timeline {
        keyFrames: [
            KeyFrame { 
                time: 1ms 
                action: function() { 
                    getRepliesInBackground();
                }
            },
            KeyFrame { 
                time: bind model.config.twitterAPISettings.getRepliesInterval 
                action: function() {}
            }
            
        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    var getDirectMessagesTimeline = Timeline {
        keyFrames: [
            KeyFrame { 
                time: 1ms 
                action: function() { 
                    getDirectMessagesInBackground();
                }
            },
            KeyFrame { 
                time: bind model.config.twitterAPISettings.getDirectMessagesInterval 
                action: function() {}
            }
            
        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    function startReceiving(): Void {
        getFriendsTimelineTimeline.play();
        getUserTimelineTimeline.play();
        getRepliesTimeline.play();
        getDirectMessagesTimeline.play();
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