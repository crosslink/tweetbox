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
import tweetbox.generic.layout.FlowBox;

function run() {
    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    var nodeStyle = Style.getApplicationStyle();
    var model = Model.getInstance();

    var stageWidth = 950;
    var stageHeight = 800;

    var controller = FrontController.getInstance();
    controller.start();

    var configDialog = ConfigDialog {
        visible: not controller.isAccountConfigured("twitter")
    }
    var aboutDialog = AboutDialog {}
    //WindowHelper.extractWindow(configDialog.stage).setAlwaysOnTop(true);

    var stage:JFXStage = JFXStage {
        title: "TweetBox"
        width: bind stageWidth
        height: bind stageHeight
        x: (screenSize.width - stageWidth) / 2
        y: (screenSize.height - stageHeight) / 2
        resizable: true
        visible: true

        icons: [
            Image {url: "{__DIR__}images/tweetboxlogo25.gif"},
            Image {url: "{__DIR__}images/tweetboxlogo100.gif"},
        ]

        visible: true

        onClose: function():Void {
            controller.exit();
        }

        scene: Scene {
            content: [
                Group {
                    var stageRef:Rectangle;
                    var menuRef:Node;
                    var statusBarRef:StatusBar;
                    var updateRef:Node;
                    content: [
                        Rectangle {
                            stroke: nodeStyle.APPLICATION_BACKGROUND_STROKE
                            x:0 y:0
                            width: bind stage.scene.width - 2
                            height: bind stage.scene.height - 2
                            fill:nodeStyle.APPLICATION_BACKGROUND_FILL

                        },
                        menuRef = FlowBox {
                            orientation: FlowBox.FLOWORIENTATION_HORIZONTAL
                            width: bind stage.scene.width * 0.8
                            translateX: 5
                            translateY: 5
                            content: [
                                Button {
                                    label: "Tweet"
                                    imageURL: "{__DIR__}icons/textfield.png"
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
                                    imageURL: "{__DIR__}icons/config.png"
                                    action: function():Void {
                                        configDialog.visible = true;
                                    }
                                },
                                Button {
                                    label: "About"
                                    action: function():Void {
                                        aboutDialog.visible = true;
                                    }
                                }
                            ]
                        },
                        HomeView {
                            translateX: 5
                            translateY: menuRef.layoutBounds.height + 10
                            width: bind stage.scene.width - 20
                            height: bind stage.scene.height - 25
                        },
                        updateRef = UpdateNode {
                            //translateY: bind stage.scene.height - updateRef.layoutBounds.height - 10
                            //translateX: bind (stage.scene.width - updateRef.layoutBounds.width)/2
                            translateX: bind Math.min(model.updateNodePosition.x, stage.scene.width - updateRef.layoutBounds.width);
                            translateY: bind Math.min(model.updateNodePosition.y, stage.scene.height - updateRef.layoutBounds.height);
                            visible: bind model.updateNodeVisible;
                            text: bind model.updateText
                        },
                        statusBarRef = StatusBar {
                            translateY: bind stage.scene.height - statusBarRef.layoutBounds.height - 10
                            width: bind stage.scene.width - 2
                            height: bind 20
                            state: bind model.state;
                        }

                    ]

                }
            ]

        }
    };

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

}