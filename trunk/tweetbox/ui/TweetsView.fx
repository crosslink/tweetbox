/*
 * TweetsView.fx
 *
 * Created on 31-okt-2008, 9:33:30
 */

package tweetbox.ui;

import javafx.scene.input.*;
import javafx.scene.*;
import javafx.scene.shape.*;
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

import twitter4j.TwitterResponse;
import twitter4j.Status;
import twitter4j.DirectMessage;
import twitter4j.User;

import tweetbox.model.*;
import tweetbox.generic.component.ScrollView;
import tweetbox.generic.util.ImageCache;
import tweetbox.control.FrontController;
import tweetbox.valueobject.TweetListVO;
import tweetbox.valueobject.TweetVO;
import tweetbox.valueobject.GroupVO;
import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */
public class TweetsView extends CustomNode, Resizable {

    public var minimizedHeight:Number;
    public var minimizedWidth:Number;

    var expandedWidth:Number = width;
    var expandedHeight:Number = height;

    override var width on replace {
        expandedWidth = width;
    }

    override var height on replace {
        expandedHeight = height;
    }

    public var tweets:List;
    
    public var newTweets:Integer on replace {
        for (row:Integer in [0..newTweets - 1]) {
            insert TweetNode {
                width: expandedWidth - 5
                tweet: TweetVO {
                    status: bind
                        if (tweets.get(row) instanceof Status)
                            tweets.get(row) as Status
                        else null
                    dm: bind
                        if (tweets.get(row) instanceof DirectMessage)
                            tweets.get(row) as DirectMessage
                        else null
                }
            } before tweetNodes[row];
        } 
        numRows = sizeof tweetNodes;
    };

    public var minimized:Boolean = false on replace {
        //expandTimeLine.rate = if (minimized) 1.0 else -1.0;
        //expandTimeLine.play();
    };
    
    public var onExpand:function(view:TweetsView):Void;
    public var onMinimize:function(view:TweetsView):Void;

    public var title:String = "updates";
    var scrollViewRef:ScrollView;
                
    var numRows:Integer;
    var groupButtonsBoxRef:VBox;
            
    var nodeStyle = Style.getApplicationStyle();

    var minimizedViewOpacityValue:Number = 1.0;
    var expandedViewOpacityValue:Number = 1.0;

    var tweetNodes:TweetNode[] = [];

    public var expandTimeLine = Timeline {
        keyFrames: [
            KeyFrame {
                time: bind 100ms
                values: [
                    expandedViewOpacityValue => 1.0 tween Interpolator.LINEAR,
                    minimizedViewOpacityValue => 1.0 tween Interpolator.LINEAR,
                ]
            }
        ]
    };

    var expandedView:Group = Group {
        opacity: bind expandedViewOpacityValue
        content: [
            Rectangle {
                stroke: nodeStyle.TWEETSVIEW_STROKE
                fill: null;
                x:0
                y:0
                width: bind expandedWidth
                height: bind expandedHeight
            },
            TitleBar {
                translateX: 2
                translateY:2
                title: bind "{title} ({numRows})"
                width: bind expandedWidth - 1

                onMouseClicked: function(me:MouseEvent):Void {
                     minimized = true;
                     onMinimize(this);
                }
            },
            scrollViewRef = ScrollView {
                hasHorizontalScrollBar: false
                translateX: 5
                translateY: 25
                height: bind expandedHeight - 25
                width: bind expandedWidth - 20
                content: bind tweetNodes
            }
        ]
    }

    var minimizedView:Group = Group {
        opacity: bind minimizedViewOpacityValue
        content: bind [
            Rectangle {
                fill: null
                stroke: nodeStyle.TWEETSVIEW_STROKE
                x:0
                y:0
                width: bind minimizedWidth
                height: bind minimizedHeight

                onMouseClicked: function(me:MouseEvent):Void {
                     minimized = false;
                     onExpand(this);
                }
            },
            TitleBar {
                translateX: 2
                translateY: 2
                title: bind "{title} ({numRows})"
                width: bind minimizedWidth-1

                onMouseClicked: function(me:MouseEvent):Void {
                     minimized = false;
                     onExpand(this);
                }
            },
            if (numRows>0) {
                ImageView {
                    translateX: 10
                    translateY: 40
                
                    image: bind profileImageForMostRecentUpdate()
                
                    clip: Rectangle {
                        width: 50
                        height: 50
                    }
                }
            } else null
        ]
    }

    var currentView:Node = bind if (minimized) minimizedView else expandedView;

    public override function create(): Node {
        numRows = tweets.size();
        return Group {
            content: bind currentView
        };
    }
    
    public override function toString():String {
        return "TweetsView[title = {title}, newTweets = {newTweets}, minimized = {minimized}] ";
    }

    bound function profileImageForMostRecentUpdate(): Image {
        var update:TwitterResponse = tweets.get(0) as TwitterResponse;
        
        var user:User = if (update instanceof Status)
            (update as Status).getUser()
        else if (update instanceof DirectMessage)
            (update as DirectMessage).getSender()
        else null;

        return if (user != null)
            ImageCache.getInstance().getImage(user.getProfileImageURL().toString())
        else
            null
    }
}