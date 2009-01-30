/*
 * TweetListVO.fx
 *
 * Created on 10-nov-2008, 23:35:37
 */

package tweetbox.valueobject;

import java.lang.System;
import java.lang.StringBuffer;

import java.util.List;
import java.util.Vector;
import java.util.Date;
import java.util.Calendar;
import java.util.Properties;

import java.io.File;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

import twitter4j.TwitterResponse;

/**
 * @author mnankman
 */

public class TweetListVO {
    public var tweets:List = new Vector();
    public var numTweets:Integer = 0;
    
    public function addTweets(tweetlist:TweetListVO) {
        var newTweets:List = new Vector();
        newTweets.addAll(tweetlist.tweets);
        newTweets.addAll(tweets);
        tweets = newTweets;
        numTweets = tweets.size();
    }
    
    public function addTweet(tweet:TweetVO) {
        tweets.add(tweet);
    }
    
    public function getTweet(i:Integer): TweetVO {
        if (tweets.size() > 0) {
            return 
            tweets.get(i) as TweetVO;
        }
        else {
            return null;
        }
    }
    
    public function addTweetsFromStatusList(statusList:List) {
        addTweetsFromStatusList(statusList, statusList.size());
    }
    
    public function addTweetsFromStatusList(statusList:List, numStatuses:Integer) {
        if (numStatuses > 0) {
            var newTweets:List = new Vector();
            var n:Integer = numStatuses;
            
            if (n > statusList.size()) n = statusList.size();
            
            for (i:Integer in [0..n - 1]) {
                newTweets.add(TweetVO {response: statusList.get(i) as TwitterResponse})
            }
            tweets.addAll(0, newTweets);
            //newTweets.addAll(tweets);
            //tweets = newTweets;
            numTweets = tweets.size();
            System.out.println("TweetListVO.numTweets = {numTweets}");
        }
    }
    
    public function clear() {
        tweets = new Vector();
        numTweets = 0;
    }
    
}
