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

import twitter4j.*;

/**
 * @author mnankman
 */

public class FrontController {
    private attribute model = Model.getInstance();
    
    private attribute isReady:Boolean = bind (model.state == State.READY);
    private attribute isError:Boolean = bind (model.state == State.ERROR);
    public attribute canExecute:Boolean = bind (isReady or isError);
    
    private attribute since:Calendar = Calendar.getInstance();
    
    private attribute twitter:AsyncTwitter;
    private attribute twitterListener:TwitterListener;
    
    public function start() {
        loadConfig();
        loadFromCache();
        var twitterAccount = getAccount("twitter");
        twitter = new AsyncTwitter(twitterAccount.login, twitterAccount.password);
        twitter.setSource("TweetBox");
        
        twitterListener = TwitterAdapter {
            
            public function updated(status:Status) {
                System.out.println("update was successfully sent");
                model.myUpdates.add(0, status);    
                model.newMyUpdates = 1;
                model.updateText = "";
                model.state = State.READY;
            }

            public function gotFriendsTimeline(statuses:List) {
                System.out.println("statuses received: " + statuses);
                model.friendUpdates.addAll(0, statuses);    
                model.newFriendUpdates = statuses.size();
                model.state = State.READY;
                System.out.println("model.newFriendUpdates = " + model.newFriendUpdates);    
            }            
            
            public function gotReplies(statuses:List) {
                System.out.println("replies received: " + statuses);
                model.replies.addAll(0, statuses);    
                model.newReplies = statuses.size();
                model.state = State.READY;
                System.out.println("model.newReplies = " + model.newReplies);    
            }            
            
            public function gotDirectMessages(statuses:List) {
                System.out.println("direct messages received: " + statuses);
                model.directMessages.addAll(0, statuses);    
                model.newDirectMessages = statuses.size();
                model.state = State.READY;
                System.out.println("model.newDirectMessages = " + model.newDirectMessages);    
            }            
            
            public function onException(e:TwitterException, method:Integer) {
                model.state = State.ERROR;
                if (method == AsyncTwitter.UPDATE) {
                    System.out.println("error during update, cause: " + e);
                    
                } else if (method == AsyncTwitter.FRIENDS_TIMELINE ) {
                    System.out.println("error during retrieval of friends timeline, cause: " + e);
          
                } else if (method == AsyncTwitter.REPLIES ) {
                    System.out.println("error during retrieval of replies, cause: " + e);
          
                } else if (method == AsyncTwitter.DIRECT_MESSAGES ) {
                    System.out.println("error during retrieval of direct messages, cause: " + e);
          
                } else {
                    
                   
                }
            }
        };
        
        getFriendsTimelineTimeline.start();
        getRepliesTimeline.start();
        getDirectMessagesTimeline.start();
    }
    
    public function exit() {
        model.state = State.EXITING;
        saveConfig();
        saveToCache();
        System.exit(0);
    }
    
    public function getFriendsTimeline() {
        if  (canExecute) {
            System.out.println("get friends timeline");
            model.state = State.RETRIEVING_TIMELINE;
            twitter.getFriendsTimelineAsync(getSinceDate(model.friendUpdates), twitterListener);
            model.state = State.READY;
        }
    }
    
    public function getReplies() {
        if  (canExecute) {
            System.out.println("get replies");
            model.state = State.RETRIEVING_REPLIES;
            twitter.getRepliesAsync(twitterListener);
            model.state = State.READY;
        }
    }
    
    public function getDirectMessages() {
        if  (canExecute) {
            System.out.println("get direct messages");
            model.state = State.RETRIEVING_DIRECT_MESSAGES;
            twitter.getDirectMessagesAsync(getSinceDate(model.directMessages), twitterListener);
            model.state = State.READY;
        }
    }
    
    public function sendUpdate(update:String) {
        if  (canExecute) {
            var twitterAccount = getAccount("twitter");
            model.state = State.SENDING_UPDATE;
            twitter.updateAsync(update, twitterListener);
        }
    }
    
    private function getSinceDate(statuses:List): Date {
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
        if  (canExecute) {
            model.state = State.RETRIEVING_SEARCHRESULTS;
            model.state = State.READY;
            System.out.println("searchResults.size = " + model.numSearchResults);model.state = State.READY;
        }
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

    public function loadFromCache() {
        var cacheFile = new File(System.getProperty("user.home")+"/tweetbox.cache");
        System.out.println("loading cache from: " + cacheFile.getPath());
        var cache:Vector = new Vector();
        try {
            var input:ObjectInputStream = new ObjectInputStream(new FileInputStream(cacheFile));
            cache = input.readObject() as Vector;
            
            model.friendUpdates = cache.get(0) as Vector;
            model.newFriendUpdates = model.friendUpdates.size();
            
            model.replies = cache.get(1) as Vector;
            model.newReplies = model.replies.size();
            
            model.myUpdates = cache.get(2) as Vector;
            model.newMyUpdates = model.myUpdates.size();
            
            model.directMessages = cache.get(3) as Vector;
            model.newDirectMessages = model.directMessages.size();
            
            System.out.println("cache loaded from: " + cacheFile.getPath());
        }
        catch (e:IOException) {
            System.out.println("could not read from cache. Cause: " + e);
        }
    }
    
    public function saveToCache() {
        var cacheFile = new File(System.getProperty("user.home")+"/tweetbox.cache");
        System.out.println("saving cache to: " + cacheFile.getPath());
        var cache:Vector = new Vector();
        cache.add(model.friendUpdates);
        cache.add(model.replies);
        cache.add(model.myUpdates);
        cache.add(model.directMessages);
        try {
            var output:ObjectOutputStream = new ObjectOutputStream(new FileOutputStream(cacheFile));
            output.writeObject(cache);
            System.out.println("cache saved to: " + cacheFile.getPath());
        }
        catch (e:IOException) {
            System.out.println("could not save cache. Cause: " + e);
        }
    }

    private attribute getFriendsTimelineTimeline = Timeline {
        keyFrames: [
            KeyFrame { 
                time: 1ms 
                action: function() { 
                    getFriendsTimeline();
                }
            },
            KeyFrame { 
                time: bind model.config.twitterAPISettings.getFriendTimelineInterval 
                action: function() {}
            }
            
        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    private attribute getRepliesTimeline = Timeline {
        keyFrames: [
            KeyFrame { 
                time: 1ms 
                action: function() { 
                    getReplies();
                }
            },
            KeyFrame { 
                time: bind model.config.twitterAPISettings.getRepliesInterval 
                action: function() {}
            }
            
        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    private attribute getDirectMessagesTimeline = Timeline {
        keyFrames: [
            KeyFrame { 
                time: 1ms 
                action: function() { 
                    getDirectMessages();
                }
            },
            KeyFrame { 
                time: bind model.config.twitterAPISettings.getDirectMessagesInterval 
                action: function() {}
            }
            
        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

  //-----------------Use Singleton pattern to get model instance -----------------------
    private static attribute instance:FrontController;

    public static function getInstance():FrontController {
        if (instance == null) {
            instance = FrontController {}
;
        }
        else {
            instance;
        }
    }

    
    
}
