/*
 * GetFriendTimelineCommand.fx
 *
 * Created on 8-nov-2008, 17:07:33
 */

package tweetbox.service.twitter;

import tweetbox.generic.command.AbstractCommand;
import java.lang.Thread;
import java.lang.Runnable;
import tweetbox.model.*;
import java.util.List;
import java.util.Date;
import java.util.ConcurrentModificationException;
import java.lang.System;
import java.lang.Exception;

/**
 * @author mnankman
 */

public class GetFriendTimelineCommand extends AbstractCommand {
    private attribute twitter = TwitterService.getInstance();
    private attribute model = Model.getInstance();
    
    public function execute(login:String, password:String, lastTime:Date): Void {
            var r:Runnable = Runnable {
                public function run() {
                    try {
                        onSuccess(twitter.getFriendsTimeline(login, password, lastTime));
                    }
                    catch (e:ServiceInvocationException) {
                        onFailure(e);
                    }
                }
            }
            var t:Thread = new Thread(r);
            model.state = State.RETRIEVING_TIMELINE;
            var uncaughtExceptionHandler = Thread.UncaughtExceptionHandler {
                public function uncaughtException(t, e) {
                    onFailure(e);
                }
            }
            t.setUncaughtExceptionHandler(uncaughtExceptionHandler);
            t.start();
            
    }
    
    public function onSuccess(result): Void  {
        var tweetsReceived:List = result as List;
        if (model.tweets == null) {
            model.tweets = tweetsReceived;
        } else {
            try {
                model.tweets.addAll(0, tweetsReceived);    
            }
            catch (e:ConcurrentModificationException) {
                onFailure(e);
            }
        }
        model.numTweets = model.tweets.size();
        model.state = State.READY;
        System.out.println("numtweets = " + model.numTweets);    
    }
    
    public function onFailure(error): Void  {
        model.state = State.ERROR;
        //System.out.println("GetFriendTimelineCommand.onFailure(" + error + ")");
    }

}
