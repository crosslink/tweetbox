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
import twitter4j.TwitterResponse;
import twitter4j.Status;
import twitter4j.DirectMessage;
import twitter4j.User;

import tweetbox.model.*;
//import tweetbox.generic.component.ScrollView;
import tweetbox.generic.component.ListBox;
import tweetbox.generic.component.Button;
import tweetbox.generic.util.ImageCache;
import tweetbox.control.FrontController;
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
    
    var newTweets = bind group.newUpdates on replace {
        var updateArray:Object[] = group.updates.toArray();
        for (row in [0..newTweets - 1]) {
            insert TweetNode {
                width: width - 5
                tweet: TweetVO {
                    response: updateArray[row] as TwitterResponse
                }
            } before tweetNodes[row];
        } 
        numRows = sizeof tweetNodes;
    };

    var title:String = bind group.title;
    //var scrollViewRef:ScrollView;
                
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
                width: width
                height: bind height
            },
            TitleBar {
                translateX: 2
                translateY:2
                title: bind "{title} ({numRows})"
                width: width - 1

                buttons: [
                    Button {
                        imageURL: "{__DIR__}icons/refresh.png"
                        width: 14
                        height: 14
                        action: group.refresh;
                    },
                    Button {
                        label: "-"
                        width: 14
                        height: 14
                        action: function() {
                            group.expanded = false;
                            onHide(group);
                        }
                    }
                ]

            },
            ListBox {
                translateX: 5
                translateY: 25
                height: bind height - 35
                width: width - 20
                model: bind tweetNodes
                cellHeight: 80
                cellRenderer: TweetCellRenderer{}
            }
//            scrollViewRef = ScrollView {
//                hasHorizontalScrollBar: false
//                translateX: 5
//                translateY: 25
//                height: bind height - 25
//                width: width - 20
//                content: VBox {
//                    content: bind tweetNodes
//                }
//            }

        ]
    }


    public override function create(): Node {
        return view;
    }

    public override function toString():String {
        return "TweetsView[title = {title}, newTweets = {newTweets}, expanded = {expanded}] ";
    }

}