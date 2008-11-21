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

public class Splash extends CustomNode {
    public attribute width:Integer;
    public attribute height:Integer;
    
    private attribute screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    
    private attribute style = Style.getApplicationStyle();
    private attribute model = Model.getInstance();
    private attribute controller = FrontController.getInstance();
    
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
                HTMLNode {
                    width: bind width - 10
                    height: bind height - 10
                    translateX: 5
                    translateY: 20
                    html: bind "<h2>TweetBox is loading...</h2>"
                    
                }
            ]

        };
    }

    public attribute frame = Frame {
        x: bind (screenSize.getWidth() - width) / 2
        y: bind (screenSize.getHeight() - height) / 2
        stage: Stage {
            fill: null
        }
        title: "TweetBox Splash"
        opacity: 0.0
        width: width
        height: height
	windowStyle: WindowStyle.TRANSPARENT
        resizable: false
        visible: false;
        
    }
    
    public function show() {
        frame.visible = true;
        fadeIn.start();
        autoHide.start();
    }
    
    public function hide() {
        System.out.println("hiding splash");
        fadeOut.start();
    }    
    
    public attribute fadeIn = Timeline {
        keyFrames: [
            KeyFrame { 
                time:1s 
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
                time:10s  
                action: function() { 
                    hide(); 
                }
            },
        ]
    };
    
}