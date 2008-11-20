/*
 * Main.fx
 *
 * Created on 6-okt-2008, 21:37:11
 */

package tweetbox.ui;

/**
 * @author mnankman
 */

import javafx.application.*;
import javafx.ext.swing.*;
import javafx.scene.*;
import javafx.scene.geometry.*;
import javafx.scene.image.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
import javafx.scene.text.*;
import javafx.scene.transform.*;
import javafx.animation.*;
import java.lang.Object;
import java.lang.System;
import com.javafxpert.custom_node.*;
import tweetbox.model.Model;
import tweetbox.model.State;
import tweetbox.valueobject.AccountVO;
import tweetbox.ui.style.Style;
import tweetbox.control.FrontController;

import java.lang.Thread;
import java.lang.Runnable;

var deckRef:DeckNode;

public class TweetBoxWidget extends CustomNode {
    
    public attribute width:Integer;
    public attribute height:Integer;
    
    private attribute style = Style.getApplicationStyle();
    
    public attribute deckRef:DeckNode;
    
    private attribute model = Model.getInstance();
    private attribute controller = FrontController.getInstance();
    private attribute tweetsView:TweetsView;
    
    public attribute alertBox = AlertBox {
        width: 200
        height: 120
    }

            
    public function create(): Node {
        return Group {
            var stageRef:Rectangle;
            var menuRef:MenuNode;
            var configRef:ConfigView;
            var updateRef:UpdateNode;
            var queryRef:QueryNode;
            var statusBarRef:StatusBar;
            content: [
                Rectangle { 
                    stroke: style.APPLICATION_BACKGROUND_STROKE
                    x:0 y:0 
                    width: bind width - 2
                    height: bind height - 2
                    arcWidth:20 
                    arcHeight:20
                    fill:style.APPLICATION_BACKGROUND_FILL
                    
                },       
                Group {
                    content: [
                        Rectangle { 
                            x:0 
                            y:0
                            width: bind width - 2
                            height: bind 20 
                            arcWidth:20 
                            arcHeight:20
                            fill:style.APPLICATION_TITLEBAR_FILL                    
                        },       
                        Text {
                            translateY: 15
                            translateX: 10
                            content: "TweetBox"
                            fill: style.APPLICATION_TITLEBAR_TEXT_FILL
                            font: style.APPLICATION_TITLEBAR_TEXT_FONT                 
                        }
                    ]
                },
                ButtonNode {
                    translateY: 3
                    translateX: bind width - 20
                    title: "exit"
                    imageURL: "{__DIR__}icons/cancel.png"
                    action:
                    function():Void {
                        fadeOut.start();
                    }
                },
                deckRef = DeckNode {
                    translateX: 3
                    translateY: 30
                    fadeInDur: 700ms
                    content: [
                    // The "Home" page
                        VBox {
                            id: "Home"
                            spacing: 4
                            content: [
                                tweetsView = TweetsView {
                                    height: bind height - 150
                                    width: bind width - 10
                                },
                                updateRef = UpdateNode {
                                    text: bind model.updateText
                                    translateX: bind width / 2 - updateRef.getWidth() / 2
                                }
                            ]
                        },
                    // The "Search" page
                        /*
                        VBox {
                            var searchResultsView:TweetsView
                            id: "Search"
                            spacing: 4
                            content: [
                                searchResultsView = TweetsView {
                                    tweets: bind model.searchResults
                                    height: bind height - 120
                                    width: bind width - 10
                                },
                                queryRef = QueryNode {
                                    translateX: bind width / 2 - updateRef.getWidth() / 2
                                }
                            ]
                        },
                        */
                    // The "Config" page
                        Group {
                            id: "Config"
                            content: [
                                configRef = ConfigView {
                                    translateX: bind width / 2 - configRef.getWidth() / 2
                                    translateY: bind height / 2
                                }
                            ]
                        },
                    // The "Profile" page
                        Group {
                            id: "Profile"
                            content: [
                                HTMLNode {
                                    width: 300
                                    html: "<h1>The profile page</h1>"
                                    font: style.TWEET_TEXT_FONT
                                }
                            ]
                        },
                    // The "Help" page
                        Group {
                            id: "Help"
                            content: [
                                HTMLNode {
                                    width: 300
                                    html: "<em>emphasized</em><br><strong>bold</strong><br><a href=\"http://www.twitter.com\">link</a>"
                                    font: style.TWEET_TEXT_FONT
                                },
                                HTMLNode {
                                    translateY:100
                                    width: 300
                                    html: "Morbi scelerisque eros cursus purus. Aenean felis mauris, tristique vitae, blandit nec, accumsan at, pede. Donec cursus pede ac mi. Fusce elementum consectetuer sapien. Nullam tempus metus in felis. Nunc viverra, risus in gravida rhoncus, erat justo congue augue, non vehicula dui quam in dui. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin at eros. Donec egestas euismod felis. Sed urna arcu, vulputate eu, dictum sit amet, auctor sit amet, sem. Proin pharetra ligula vitae elit. Ut lorem ante, semper vitae, dapibus id, consequat et, magna. "
                                    font: style.TWEET_TEXT_FONT
                                }

                            ]

                        }
                    
                    ]
                },
                menuRef = MenuNode {
                    translateX: bind width / 2 - menuRef.getWidth() / 2
                    translateY: bind height - 50
                    buttons: [
                        ButtonNode {
                            title: "Home"
                            imageURL: "{__DIR__}icons/home.png"
                            action:
                            function():Void {
                                deckRef.visibleNodeId = "Home";
                            }
                        },
                        /*ButtonNode {
                            title: "Search"
                            imageURL: "{__DIR__}icons/find.png"
                            action:
                            function():Void {
                                deckRef.visibleNodeId = "Search";
                            }
                        },*/
                        ButtonNode {
                            title: "Profile"
                            imageURL: "{__DIR__}icons/friends.png"
                            action:
                            function():Void {
                                deckRef.visibleNodeId = "Profile";
                            }
                        },
                        ButtonNode {
                            title: "Config"
                            imageURL: "{__DIR__}icons/config.png"
                            action:
                            function():Void {
                                deckRef.visibleNodeId = "Config";
                            }
                        },
                        ButtonNode {
                            title: "Help"
                            imageURL: "{__DIR__}icons/help.png"
                            action:
                            function():Void {
                                alertBox.show(0,0,0);
                                deckRef.visibleNodeId = "Help";
                            }
                        }
                    ]
                },
                statusBarRef = StatusBar {
                    translateY: bind height - 22
                    width: bind width - 2
                    height: bind 20          
                    state: bind model.state;
                }
                
            ]

        };
    }
    
    public attribute frame = Frame {
        stage: Stage {
            fill: null
        }
        title: "TweetBox"
        opacity: 0.0
        width: width
        height: height
	windowStyle: WindowStyle.TRANSPARENT
        resizable: true
    }
    
    public attribute fadeIn = Timeline {
        keyFrames: [
            KeyFrame { time:1s values:frame.opacity => 1.0 tween Interpolator.LINEAR
            },
        ]
    };
    
    public attribute fadeOut = Timeline {
        keyFrames: [
            KeyFrame { time:1s values:frame.opacity => 0.0 tween Interpolator.LINEAR 
                action: function() { controller.exit(); }
            },
        ]
    };
    
    public attribute checkUpdates = Timeline {
        keyFrames: [
            KeyFrame { 
                time: 1s 
                action: function() { 
                    if (model.newFriendUpdates + model.newReplies + model.newDirectMessages > 0) {
                        alertBox.show(model.newFriendUpdates, model.newReplies, model.newDirectMessages);
                    }
                    if (model.newFriendUpdates + model.newReplies + model.newDirectMessages + model.newMyUpdates > 0) {
                        tweetsView.refreshContents();
                        model.newFriendUpdates = 0;
                        model.newDirectMessages = 0;
                        model.newReplies = 0;
                        model.newMyUpdates = 0;
                    }
                }
            }
        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };
}

var controller = FrontController.getInstance();
controller.start();

var widget = TweetBoxWidget {
    width: 510
    height: 700
}

widget.alertBox.frame.stage.content = [widget.alertBox];

widget.checkUpdates.start();

widget.frame.stage.content = [widget];

if (controller.getAccount("twitter") == null) 
    widget.deckRef.visibleNodeId = "Config"
else
    widget.deckRef.visibleNodeId = "Home";
    
tweetbox.util.WindowDragUtil.makeFXFrameDraggable(widget.frame);
widget.frame.visible = true;
widget.fadeIn.start();


