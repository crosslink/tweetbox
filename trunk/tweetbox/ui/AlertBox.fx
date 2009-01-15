/*
 * AlertWindow.fx
 *
 * Created on 19-nov-2008, 14:36:17
 */

package tweetbox.ui;

//import javafx.application.*;
import javafx.scene.input.*;
import javafx.scene.Scene;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.*;
import javafx.scene.transform.*;
import javafx.animation.*;
import javafx.scene.text.*;
import javafx.stage.*;
import javafx.scene.layout.VBox;

import java.lang.System;
import java.awt.Toolkit;
import java.awt.Dimension;

import tweetbox.generic.component.HTMLNode;
import tweetbox.model.Model;
import tweetbox.ui.style.Style;
import tweetbox.control.FrontController;

/**
 * @author mnankman
 */

public class AlertBox {
    public var width:Integer;
    public var height:Integer;
    
    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    
    var nodeStyle = Style.getApplicationStyle();
    var model = Model.getInstance();
    var controller = FrontController.getInstance();
    
    var stageOpacityValue:Number = 0.0;

    var visible:Boolean = bind (sizeof model.alertMessages > 0) on replace {
        if (visible) show() else hide();
    };
    
    var content:Group = Group {
        content: [
            Rectangle {
                translateX:0
                translateY:0
                stroke: nodeStyle.APPLICATION_BACKGROUND_STROKE
                x:0 y:0
                width: bind width - 2
                height: bind height - 2
                arcWidth:20
                arcHeight:20
                fill:nodeStyle.APPLICATION_BACKGROUND_FILL

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
                        fill:nodeStyle.APPLICATION_TITLEBAR_FILL
                    },
                    Text {
                        translateY: 15
                        translateX: 10
                        content: "TweetBox Alert"
                        fill: nodeStyle.APPLICATION_TITLEBAR_TEXT_FILL
                        font: nodeStyle.APPLICATION_TITLEBAR_TEXT_FONT
                    }
                ]
            },
            VBox {
                translateX: 5
                translateY: 20
                content: bind for (message in model.alertMessages) {
                    HTMLNode {
                        width: bind width - 10
                        height: bind height - 10
                        html: message
                        font: nodeStyle.ALERT_TEXT_FONT
                    }
                }
            }
        ]
    };

    var stage:Stage = Stage {
        x: bind screenSize.width - width - 25
        y: bind screenSize.height - height - 50
        title: "TweetBox Alert"
        opacity: bind stageOpacityValue
        width: width
        height: height
        style: StageStyle.TRANSPARENT
        resizable: false
        visible: false;
        scene: Scene {
            content: bind content
        }
    };
    
    public function show() {
        stage.visible = true;
        //fadeIn.play();
        autoHide.play();
    }
    
    public function hide() {
        System.out.println("hiding alertBox");
        stage.visible = false;
        //fadeOut.play();
    }    
    
    var fadeIn = Timeline {
        keyFrames: [
            KeyFrame { 
                time:300ms 
                values:stageOpacityValue => 1.0 tween Interpolator.LINEAR
                
            }
        ]
    };
    
    var fadeOut = Timeline {
        keyFrames: [
            KeyFrame { 
                time:300ms 
                values:stageOpacityValue => 0.0 tween Interpolator.LINEAR
                action: function() {
                    stage.visible = false;
                }
            }
        ]
    };

    var autoHide = Timeline {
        keyFrames: [
            KeyFrame { 
                time:20s
                action: function() { 
                    hide(); 
                }
            }
        ]
    };
    
}