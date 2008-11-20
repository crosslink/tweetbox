/*
 * TweetsView.fx
 *
 * Created on 31-okt-2008, 9:33:30
 */

package tweetbox.ui;

import javafx.input.*;
import javafx.scene.*;
import javafx.scene.geometry.*;
import javafx.scene.transform.*;
import javafx.scene.effect.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
import javafx.animation.*;
import javafx.scene.text.*;
import javafx.scene.image.*;
import javafx.ext.swing.*;

import java.lang.System;
import java.util.List;

import tweetbox.model.*;
import tweetbox.generic.component.ScrollView;
import tweetbox.control.FrontController;
import tweetbox.valueobject.TweetListVO;
import tweetbox.valueobject.TweetVO;

/**
 * @author mnankman
 */
public class TweetsView extends CustomNode {

  /*
   * Contains the height of the view in pixels.
   */
    public attribute height:Integer;

  /*
   * Contains the width of the view in pixels.
   */
    public attribute width:Integer;
    
    public attribute tweetList:TweetListVO = TweetListVO{};
    
    public attribute numTweets:Integer = bind tweetList.numTweets;
    
    private attribute model = Model.getInstance();
    private attribute controller = FrontController.getInstance();
    
    public function create(): Node {
        return Group {
            var numRows:Integer = bind numTweets;
            var scrollViewRef:ScrollView
            content: 
                scrollViewRef = ScrollView {
                    height: bind height
                    width: bind width
                    content: bind for (row:Integer in [0..numRows-1]) {
                        TweetNode {
                            width: bind width - scrollViewRef.vertScrollbarWidth;
                            tweet: bind tweetList.getTweet(row);
                        }                                                
                    }
                }
        };
    }

    public function refreshContents() { 
        if (controller.canExecute) {
            tweetList.addTweetsFromStatusList(model.friendUpdates, model.newFriendUpdates);
            tweetList.addTweetsFromStatusList(model.replies, model.newReplies);
            tweetList.addTweetsFromStatusList(model.myUpdates, model.newMyUpdates);       
            tweetList.addTweetsFromStatusList(model.directMessages, model.newDirectMessages);       
        }
    }

}