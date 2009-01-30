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
import tweetbox.generic.component.Button;
import tweetbox.generic.util.ImageCache;
import tweetbox.control.FrontController;
import tweetbox.valueobject.TweetListVO;
import tweetbox.valueobject.TweetVO;
import tweetbox.valueobject.UserVO;
import tweetbox.valueobject.GroupVO;
import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */
public class TweetsView extends CustomNode, Resizable {

    public var group:GroupVO;
    public var minimizedHeight:Number;
    public var minimizedWidth:Number;

    var expanded:Boolean = bind group.expanded;


    public var onHide:function(group:GroupVO):Void;
    
    var expandedWidth:Number = width;
    var expandedHeight:Number = height;

    override var width on replace {
        expandedWidth = width;
    }

    override var height on replace {
        expandedHeight = height;
    }

    var newTweets = bind group.newUpdates on replace {
        for (row in [0..newTweets - 1]) {
            insert TweetNode {
                width: expandedWidth - 5
                tweet: TweetVO {
                    response: group.updates.get(row) as TwitterResponse
                }
            } before tweetNodes[row];
        } 
        numRows = sizeof tweetNodes;
    };

    var title:String = bind group.title;
    var scrollViewRef:ScrollView;
                
    var numRows:Integer;
            
    var nodeStyle = Style.getApplicationStyle();

    var tweetNodes:TweetNode[] = [];

    var view:Group = Group {
        visible: bind expanded
        content: [
            Rectangle {
                stroke: nodeStyle.TWEETSVIEW_STROKE
                fill: null;
                x:0
                y:0
                width: bind if (expanded) expandedWidth else minimizedWidth
                height: bind if (expanded) expandedHeight else minimizedHeight
            },
            TitleBar {
                translateX: 2
                translateY:2
                title: bind "{title} ({numRows})"
                width: bind expandedWidth - 1

                buttons: [
                    Button {
                        label: "r"
                        width: 10
                        height: 10
                        action: group.refresh;
                    },
                    Button {
                        label: "-"
                        width: 10
                        height: 10
                        action: function() {
                            group.expanded = false;
                            onHide(group);
                        }
                    }
                ]

            },
            scrollViewRef = ScrollView {
                hasHorizontalScrollBar: false
                translateX: 5
                translateY: 25
                height: bind expandedHeight - 25
                width: bind expandedWidth - 20
                content: VBox {
                    content: bind tweetNodes
                }
            }
        ]
    }


    public override function create(): Node {
        return view;
    }

    public override function toString():String {
        return "TweetsView[title = {title}, newTweets = {newTweets}, expanded = {expanded}] ";
    }

}