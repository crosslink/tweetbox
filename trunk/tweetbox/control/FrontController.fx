/*
 * FrontController.fx
 *
 * Created on 7-nov-2008, 23:26:27
 */

package tweetbox.control;

import tweetbox.model.*;
import tweetbox.service.twitter.TwitterService;
import tweetbox.service.twitter.GetFriendTimelineCommand;
import java.lang.System;
import java.util.Date;
import java.util.List;
import java.util.ConcurrentModificationException;
import org.json.simple.JSONObject;

/**
 * @author mnankman
 */

public class FrontController {
    private attribute model = Model.getInstance();
    
    private attribute isReady:Boolean = bind (model.state == State.READY);
    private attribute isError:Boolean = bind (model.state == State.ERROR);
    private attribute canExecute:Boolean = bind (isReady or isError);
    
    private attribute lastTime:Date = null;
    
    private attribute getFriendTimelineCommand = GetFriendTimelineCommand {}
    
    public function getTweets() {
        if  (canExecute) {
            var twitterAccount = getAccount("twitter");
            if (twitterAccount != null) {
                getFriendTimelineCommand.execute(twitterAccount.login, twitterAccount.password, lastTime);
                lastTime = new Date();
            }
        }
    }
    
    public function getTweet(i:Integer): JSONObject {
        try {
            return model.tweets.get(i) as JSONObject;
        } 
        catch (e:ConcurrentModificationException) {
            return null;
        }
    }

    public function search(query:String) {
        if  (canExecute) {
            model.state = State.RETRIEVING_SEARCHRESULTS;
            model.searchResults = TwitterService.getInstance().search(query);
            model.numSearchResults = model.searchResults.size();
            model.state = State.READY;
            System.out.println("searchResults.size = " + model.numSearchResults);model.state = State.READY;
        }
    }
    
    public function sendUpdate(update:String) {
        if  (canExecute) {
            var twitterAccount = getAccount("twitter");
            model.state = State.SENDING_UPDATE;
            TwitterService.getInstance().sendUpdate(twitterAccount.login, twitterAccount.password, update);
            model.state = State.READY;
        }
    }
    
    public function updateAccount(updatedAccount:Account) {
        model.config.updateAccount(updatedAccount);
    }

    public function addAccount(newAccount:Account) {
        model.config.addAccount(newAccount);
    }
    
    public function getAccount(id:String) {
        return model.config.getAccount(id);
    }
    
    public function exit() {
        model.state = State.EXITING;
        saveConfig();
        System.exit(0);
    }
    
    public function saveConfig() {
        model.config.save();
    }
    
    public function loadConfig() {
        model.config.load();
    }

  //-----------------Use Singleton pattern to get model instance -----------------------
    private static attribute instance:FrontController;

    public static function getInstance():FrontController {
        if (instance == null) {
            instance = FrontController {
               
            }
;
        }
        else {
            instance;
        }
    }
}
