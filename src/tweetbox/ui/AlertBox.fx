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
import javafx.lang.Duration;
import javafx.scene.text.*;
import javafx.stage.*;
import javafx.scene.layout.VBox;
import javafx.scene.media.MediaPlayer;
import javafx.scene.media.Media;

import java.lang.System;
import java.awt.Toolkit;
import java.awt.Dimension;

import org.jfxtras.stage.JFXStage;

import tweetbox.generic.component.HTMLNode;
import tweetbox.model.Model;
import tweetbox.ui.style.Style;
import tweetbox.control.FrontController;
import tweetbox.valueobject.TweetVO;
import javafx.scene.paint.Color;

/**
 * @author mnankman
 */

public class AlertBox {
//    var width:Number = bind content.layoutBounds.width;
//    var height:Number = bind content.layoutBounds.height;

    public var onClick: function();

    public var autoHideDelay:Duration = 10s;

    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    
    var nodeStyle = bind Style.getApplicationStyle();
    var model = Model.getInstance();
    var controller = FrontController.getInstance();
    
    var visibleStagePart:Number = 0.0;

    var messageCount:Integer = bind model.alertMessageCount on replace {
        if (messageCount>0) show() else hide();
    };

    // a media player for playing a short beep when new tweets arrive
    var mediaPlayer = MediaPlayer{
        media: Media {
            source: "http://www.xs4all.nl/~mnankman/tweetbox/beep.mp3"
        }
    }

    var messageBox:VBox;
    
    var content:Group = Group {
        content: [
            Rectangle {
                cache:true
                translateX:0
                translateY:0
                stroke: bind nodeStyle.APPLICATION_BACKGROUND_STROKE
                strokeWidth: 3
                x:0 y:0
                width: bind messageBox.layoutBounds.width + 10
                height: bind 20 + messageBox.layoutBounds.height + 10
                fill: bind nodeStyle.APPLICATION_BACKGROUND_FILL

                onMouseClicked:
                    function(me:MouseEvent):Void {
                        hide();
                        onClick();
                    }
            },
            Group {
                content: [
                    Rectangle {
                        x:3
                        y:3
                        width: bind messageBox.layoutBounds.width + 4
                        height: bind 20
                        fill: bind nodeStyle.APPLICATION_TITLEBAR_FILL
                    },
                    Text {
                        translateY: 15
                        translateX: 10
                        content: "TweetBox Alert"
                        fill: bind nodeStyle.APPLICATION_TITLEBAR_TEXT_FILL
                        font: bind nodeStyle.APPLICATION_TITLEBAR_TEXT_FONT
                    }
                ]
            },
            messageBox = VBox {
                translateX: 5
                translateY: 40
                content: bind for (message in model.alertMessages) {
                    if (message instanceof String)
                        Text {
                            wrappingWidth: 400
                            content: message as String
                            fill: bind nodeStyle.ALERT_TEXT_FILL
                            font: bind nodeStyle.ALERT_TEXT_FONT
                        }
                    else if (message instanceof Node) {
                        message as Node
                    }
                    else if (message instanceof TweetVO) {
                        TweetNode {
                            width: 400
                            height: 80
                            tweet: message as TweetVO
                        }
                    }
                    else {
                        null
                    }
                }
            }
        ]
    };

    var stage:JFXStage = JFXStage {
        alwaysOnTop: true
        x: bind screenSize.width - content.layoutBounds.width - 25
        y: bind screenSize.height - content.layoutBounds.height  - 50 //* visibleStagePart
        title: "TweetBox Alert"
        width: bind content.layoutBounds.width
        height: bind content.layoutBounds.height
        style: StageStyle.TRANSPARENT
        resizable: false
        visible: false;
        scene: Scene {
            content: bind content
        }

    };
    
    public function show() {
        if (not stage.visible) {
            println("showing alertBox pos=({stage.x},{stage.y}) dim=({stage.width}x{stage.height})");
            stage.visible = true;
            slide.rate = 1.0;
            mediaPlayer.play();
            slide.play();
            autoHide.play();
        }
    }
    
    public function hide() {
        if (stage.visible) {
            println("hiding alertBox");
            controller.clearAlertMessages();
            //slide.rate = -1.0;
            //slide.play();
            stage.visible = false;
            mediaPlayer.stop();
        }
    }    
    
    var slide = Timeline {
        keyFrames: [
            KeyFrame { 
                time:400ms
                values:visibleStagePart => 1.0 tween Interpolator.LINEAR

            }
        ]
    };
    

    var autoHide = Timeline {
        keyFrames: [
            KeyFrame { 
                time: bind autoHideDelay
                action: function() { 
                    hide(); 
                }
            }
        ]
    };
    
}

public function run(): Void {
    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    println("screensize: {screenSize.width} x {screenSize.height}");
    
    var ab = AlertBox {
        autoHideDelay: 24h
        onClick: function() {
            System.exit(0);
        }
    }
    FrontController.getInstance().addAlertMessage("Click this box to close it");
    FrontController.getInstance().addAlertMessageObject(
            Circle {
                centerX: 50, centerY: 100
                radius: 20
                fill: Color.BLACK
            }
    );
    ab.show();
}