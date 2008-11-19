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
import tweetbox.ui.HTMLNode;
import javafx.scene.geometry.*;
import tweetbox.model.Model;
import tweetbox.ui.style.Style;
import tweetbox.control.FrontController;
import javafx.scene.transform.*;
import javafx.animation.*;

/**
 * @author mnankman
 */

public class AlertBox extends CustomNode {
    public attribute width:Integer;
    public attribute height:Integer;
    
    private attribute style = Style.getApplicationStyle();
    private attribute model = Model.getInstance();
    private attribute controller = FrontController.getInstance();

    public function create(): Node {
        return Group {
            content: [
                Rectangle { 
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
                    width: 300
                    height: 200
                    html: "<h1>new updates</h1>"
                }
            ]

        };
    }

    public attribute frame = Frame {
        x:800
        y:0
        stage: Stage {
            fill: null
        }
        title: "TweetBox Alert"
        opacity: 0.0
        width: width
        height: height
	windowStyle: WindowStyle.TRANSPARENT
        resizable: true
        visible: false;
    }
    
    public function show() {
        frame.visible = true;
        fadeIn.start;
    }
    
    public function hide() {
        fadeOut.start;
    }    
    
    public attribute fadeIn = Timeline {
        keyFrames: [
            KeyFrame { time:300ms values:frame.opacity => 1.0 tween Interpolator.LINEAR
            },
            KeyFrame { time:5s  
                timelines: [fadeOut]
            },
        ]
    };
    
    public attribute fadeOut = Timeline {
        keyFrames: [
            KeyFrame { time:1s values:frame.opacity => 0.0 tween Interpolator.LINEAR 
                action: function() { 
                    frame.visible = false; 
                }
            },
        ]
    };
    
}