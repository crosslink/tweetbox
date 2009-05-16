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

/**
 * @author mnankman
 */

public class AlertBox {
    public var width:Integer;
    public var height:Integer;

    public var onClick: function();

    public var autoHideDelay:Duration = 10s;

    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    
    var nodeStyle = bind Style.getApplicationStyle();
    var model = Model.getInstance();
    var controller = FrontController.getInstance();
    
    var stageOpacityValue:Number = 0.0;

    var messageCount:Integer = bind model.alertMessageCount on replace {
        if (messageCount>0) show() else hide();
    };

    // a media player for playing a short beep when new tweets arrive
    var mediaPlayer = MediaPlayer{
        media: Media {
            source: "http://www.xs4all.nl/~mnankman/tweetbox/beep.mp3"
        }
    }
    
    var content:Group = Group {
        content: [
            Rectangle {
                cache:true
                translateX:0
                translateY:0
                stroke: bind nodeStyle.APPLICATION_BACKGROUND_STROKE
                strokeWidth: 3
                x:0 y:0
                width: bind width - 2
                height: bind height - 2
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
                        width: bind width - 6
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
            VBox {
                translateX: 5
                translateY: 40
                content: bind for (message in model.alertMessages) {
                    Text {
                        wrappingWidth: bind width - 10
                        content: message
                        fill: bind nodeStyle.ALERT_TEXT_FILL
                        font: bind nodeStyle.ALERT_TEXT_FONT
                    }
                }
            }
        ]
    };

    var stage:JFXStage = JFXStage {
        alwaysOnTop: true
        x: screenSize.width - width - 25
        y: screenSize.height - height - 50
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
        if (not stage.visible) {
            println("showing alertBox pos=({stage.x},{stage.y}) dim=({stage.width}x{stage.height})");
            stage.visible = true;
            fade.rate = 1.0;
            mediaPlayer.play();
            fade.play();
            autoHide.play();
        }
    }
    
    public function hide() {
        if (stage.visible) {
            println("hiding alertBox");
            controller.clearAlertMessages();
            fade.rate = -1.0;
            fade.play();
            mediaPlayer.stop();
        }
    }    
    
    var fade = Timeline {
        keyFrames: [
            KeyFrame { 
                time:500ms
                values:stageOpacityValue => 1.0 tween Interpolator.LINEAR
                action: function() {
                    //stage.visible = stageOpacityValue>0;
                }

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
        width: 300
        height: 300
        autoHideDelay: 24h
        onClick: function() {
            System.exit(0);
        }
    }
    FrontController.getInstance().addAlertMessage("Click this box to close it");
    ab.show();
}