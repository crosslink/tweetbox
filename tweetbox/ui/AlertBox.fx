/*
 * AlertWindow.fx
 *
 * Created on 19-nov-2008, 14:36:17
 */

package tweetbox.ui;

import javafx.application.*;
import javafx.input.*;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.geometry.*;
import javafx.scene.transform.*;
import javafx.animation.*;
import javafx.scene.text.*;

import java.lang.System;
import java.awt.Toolkit;
import java.awt.Dimension;

import tweetbox.ui.HTMLNode;
import tweetbox.model.Model;
import tweetbox.ui.style.Style;
import tweetbox.control.FrontController;

/**
 * @author mnankman
 */

public class AlertBox extends CustomNode {
    public attribute width:Integer;
    public attribute height:Integer;
    
    private attribute screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    
    private attribute style = Style.getApplicationStyle();
    private attribute model = Model.getInstance();
    private attribute controller = FrontController.getInstance();
    
    private attribute newFriendUpdates:Integer;
    private attribute newReplies:Integer;
    private attribute newDirectMessages:Integer;

    public function create(): Node {
        return Group {
            content: [
                Rectangle { 
                    translateX:0
                    translateY:0
                    stroke: style.APPLICATION_BACKGROUND_STROKE
                    x:0 y:0 
                    width: bind width - 2
                    height: bind height - 2
                    arcWidth:20 
                    arcHeight:20
                    fill:style.APPLICATION_BACKGROUND_FILL
                    
                    onMouseClicked:
                        function(me:MouseEvent):Void {
                            hide();
                        }
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
                            content: "TweetBox Alert"
                            fill: style.APPLICATION_TITLEBAR_TEXT_FILL
                            font: style.APPLICATION_TITLEBAR_TEXT_FONT                 
                        }
                    ]
                },
                HTMLNode {
                    width: bind width - 10
                    height: bind height - 10
                    translateX: 5
                    translateY: 20
                    html: bind "<center>{newFriendUpdates} new updates<br>{newReplies} new replies<br>{newDirectMessages} new direct messages</center>"
                    
                }
            ]

        };
    }

    public attribute frame = Frame {
        x: bind screenSize.getWidth() - width - 25
        y: bind screenSize.getHeight() - height - 50
        stage: Stage {
            fill: null
        }
        title: "TweetBox Alert"
        opacity: 0.0
        width: width
        height: height
	windowStyle: WindowStyle.TRANSPARENT
        resizable: false
        visible: false;
        
    }
    
    public function show(u:Integer, r:Integer, d:Integer) {
        newFriendUpdates = u;
        newReplies = r;
        newDirectMessages = d;
        frame.visible = true;
        fadeIn.start();
        autoHide.start();
    }
    
    public function hide() {
        System.out.println("hiding alertBox");
        fadeOut.start();
    }    
    
    public attribute fadeIn = Timeline {
        keyFrames: [
            KeyFrame { 
                time:300ms 
                values:frame.opacity => 1.0 tween Interpolator.LINEAR
                
            },
        ]
    };
    
    public attribute fadeOut = Timeline {
        keyFrames: [
            KeyFrame { 
                time:300ms 
                values:frame.opacity => 0.0 tween Interpolator.LINEAR 
                action: function() {
                    frame.visible = false;
                }
            },
        ]
    };

    public attribute autoHide = Timeline {
        keyFrames: [
            KeyFrame { 
                time:5s  
                action: function() { 
                    hide(); 
                }
            },
        ]
    };
    
}