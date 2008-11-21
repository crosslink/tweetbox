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
import tweetbox.valueobject.GroupVO;

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
    
    
    private attribute selectedGroup:GroupVO = model.groups[0]; 

    private attribute groupButtons:GroupButton[] = bind [
        for (group:GroupVO in model.groups) {
            GroupButton {
                width: 150
                height: 40
                groupId: bind group.id
                caption: bind group.title
                newUpdates: bind group.newUpdates
                imageURL: bind group.imageURL
                onSelected: bind function(id:String) {
                    selectGroup(group.id)
                }
            }                          
        }
    ];
    
    public function create(): Node {
        selectGroup("all");
        return Group {
            var numRows:Integer = bind numTweets;
            var scrollViewRef:ScrollView;
            var groupButtonsBoxRef:VBox;
            var scrollViewWidth:Number = bind width - groupButtonsBoxRef.getWidth() - 5
            content: [
                scrollViewRef = ScrollView {
                    height: bind height
                    width: bind scrollViewWidth
                    content: bind for (row:Integer in [0..numRows-1]) {
                        TweetNode {
                            width: bind scrollViewWidth - 5
                            tweet: bind tweetList.getTweet(row);
                        }                                                
                    }
                },
                groupButtonsBoxRef = VBox {
                    translateX: width - 150
                    translateY: 0
                    content: bind groupButtons
                }
            ]
        };
    }
    
    public function selectGroup(id:String) {
        System.out.println("showUpdates: " + id);
        var newSelection:GroupVO[] = for (group:GroupVO in model.groups) {
            if (group.id == id) group else null;
        }
        if (newSelection.size()>0) {
            selectedGroup = newSelection[0];
            for (button:GroupButton in groupButtons) {
                button.selected = (button.groupId == id);
            }
            refreshContents();
        }
    }
    
    public function refreshContents() { 
        if (controller.canExecute) {
            tweetList.clear();
            if (selectedGroup.id == "all") {
                tweetList.addTweetsFromStatusList(model.friendUpdates);
                tweetList.addTweetsFromStatusList(model.replies);
                tweetList.addTweetsFromStatusList(model.myUpdates);       
                tweetList.addTweetsFromStatusList(model.directMessages);       
            }
            else if (selectedGroup.id == "replies") {
                tweetList.addTweetsFromStatusList(model.replies);
            }
            else if (selectedGroup.id == "direct") {
                tweetList.addTweetsFromStatusList(model.directMessages);
            }
        }
    }

}