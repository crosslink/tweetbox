/*
 * Main.fx
 *
 * Created on 6-okt-2008, 21:37:11
 */

package tweetbox.ui;

/**
 * @author mnankman
 */

import javafx.scene.*;
import javafx.scene.shape.*;
import javafx.scene.image.*;
import javafx.scene.layout.*;
import javafx.scene.transform.*;
import javafx.stage.*;
import javafx.animation.*;
import javafx.scene.text.Text;
import javafx.geometry.Point2D;
import javafx.scene.layout.HBox;

import org.jfxtras.stage.JFXStage;
import org.jfxtras.stage.WindowHelper;

import java.lang.Object;
import java.lang.Math;
import java.awt.Toolkit;
import java.awt.Dimension;
import java.awt.Frame;

import tweetbox.model.Model;
import tweetbox.model.State;
import tweetbox.ui.style.Style;
import tweetbox.control.FrontController;
import tweetbox.generic.component.ScrollView;
import tweetbox.generic.component.Button;
import tweetbox.generic.component.Window;
import tweetbox.generic.component.Dialog;
import tweetbox.generic.component.Balloon;
import tweetbox.generic.layout.FlowBox;

var aboutDialog:Dialog = null;
var configDialog:Dialog = null;


function showAboutDialog(scene:Scene) {
    if (aboutDialog == null) {
        aboutDialog = AboutDialog.create();
    }
    aboutDialog.open(scene);
}

function showConfigDialog(scene:Scene) {
    if (configDialog == null) {
        configDialog = ConfigDialog.create();
    }
    configDialog.open(scene);
}

var stage:JFXStage;
var balloon:Balloon;

public function showBalloon(x:Number, y:Number, toX:Number, toY:Number, content:Node) {
    hideBalloon();
    balloon = Balloon {
        x: Math.min(Math.max(x,0.0), stage.scene.width - balloon.layoutBounds.width)
        y: Math.min(Math.max(y,0.0), stage.scene.height - balloon.layoutBounds.height)
        toX: toX
        toY: toY
        content: content
    }
    insert balloon into stage.scene.content;
}

public function hideBalloon() {
    if (balloon != null) delete balloon from stage.scene.content;
}

function run() {
    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    var nodeStyle = bind Style.getApplicationStyle();
    var model = Model.getInstance();

    var stageWidth:Number = 950;
    var stageHeight:Number = 800;

    var controller = FrontController.getInstance();

    //WindowHelper.extractWindow(configDialog.stage).setAlwaysOnTop(true);

    var stageRef:Rectangle;
    var menuRef:Node;
    var statusBarRef:StatusBar;
    var updateRef:Node;
    var errorNode:Node;

    var contentGroup:Group;

    stage = JFXStage {
        title: "{model.appInfo.name} {model.appInfo.versionString}"
        width: stageWidth
        height: stageHeight
        x: (screenSize.width - stageWidth) / 2
        y: (screenSize.height - stageHeight) / 2
        resizable: true
        visible: true

        icons: [
            Image {url: "{__DIR__}images/tweetboxlogo25.gif"},
            Image {url: "{__DIR__}images/tweetboxlogo100.gif"},
        ]

        visible: false

        onClose: function():Void {
            controller.exit();
        }

        scene: Scene {
            content: [
                contentGroup = Group {
                    cache: true
                    content: [
                        Rectangle {
                            stroke: bind nodeStyle.APPLICATION_BACKGROUND_STROKE
                            x:0.0
                            y:0.0
                            width: bind stage.scene.width - 2
                            height: bind stage.scene.height - 2
                            fill: bind nodeStyle.APPLICATION_BACKGROUND_FILL

                        },
                        menuRef = HBox {
                            translateX: 5
                            translateY: 5
                            content: [
                                Button {
                                    label: "Tweet"
                                    imageURL: "{__DIR__}icons/comment.png"
                                    action: function():Void {
                                        if (not model.updateNodeVisible) {
                                            model.updateNodeVisible = true;
                                            model.directMessageMode = false;
                                            model.updateNodePosition = Point2D {
                                                x: menuRef.layoutBounds.minX + menuRef.layoutBounds.width + 10
                                                y: menuRef.layoutBounds.minY + 5
                                            }
                                        }
                                    }
                                },
                                Button {
                                    label: "Config"
                                    imageURL: "{__DIR__}icons/bullet_wrench.png"
                                    action: function():Void {
                                        showConfigDialog(stage.scene);
                                    }
                                },
                                Button {
                                    label: "About"
                                    action: function():Void {
                                        showAboutDialog(stage.scene);
                                    }
                                }
                            ]
                        },
                        errorNode = ErrorNode {
                            translateX: bind stage.scene.width - errorNode.layoutBounds.width - 5
                            translateY: 5
                        }
                        HomeView {
                            translateX: 5
                            translateY: menuRef.layoutBounds.height + 10
                            width: bind stage.scene.width - 20
                            height: bind stage.scene.height - 25
                        },
                        updateRef = UpdateNode {
                            translateX: bind Math.min(model.updateNodePosition.x, stage.scene.width - updateRef.layoutBounds.width);
                            translateY: bind Math.min(model.updateNodePosition.y, stage.scene.height - updateRef.layoutBounds.height);
                            visible: bind model.updateNodeVisible;
                            text: bind model.updateText
                        },
                        statusBarRef = StatusBar {
                            translateY: bind stage.scene.height - statusBarRef.layoutBounds.height - 10
                            width: bind stage.scene.width - 2
                            height: 20
                            state: bind model.state;
                        }
                    ]

                }
            ]

        }
    };

    controller.start(stage);

    var windowFrame:Frame = stage.getWindow().getOwner() as Frame;
    
    var alertBox = AlertBox {
        width: 200
        height: 120
        onClick: function() {
            if (windowFrame.getState()==Frame.ICONIFIED) windowFrame.setState(Frame.NORMAL);
            windowFrame.setVisible(true);
            windowFrame.repaint();
            stage.getWindow().toFront();
            stage.getWindow().requestFocus();
        }
    }

    stage.visible = true;

    if (model.needLoginCredentials) {
        showConfigDialog(stage.scene);
    }
}