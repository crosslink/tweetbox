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
import java.lang.Object;
import java.awt.Toolkit;
import java.awt.Dimension;

import tweetbox.model.Model;
import tweetbox.model.State;
import tweetbox.ui.style.Style;
import tweetbox.control.FrontController;
import tweetbox.generic.component.ScrollView;
import tweetbox.generic.component.Button;
import tweetbox.generic.component.Window;
import tweetbox.ui.layout.FlowBox;

var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();

var nodeStyle = Style.getApplicationStyle();

var model = Model.getInstance();

var controller = FrontController.getInstance();

var alertBox = AlertBox {
    width: 200
    height: 120
}

var configDialog = ConfigDialog {}

var stageWidth = 810;
var stageHeight = 700;

var stage:Stage = Stage {
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
                                label: "Config"
                                imageURL: "{__DIR__}icons/config.png"
                                action:
                                function():Void {
                                    configDialog.visible = true;
                                }
                            }
                        ]
                    },
                    HomeView {
                        translateX: 5
                        translateY: menuRef.layoutBounds.height + 10
                        width: bind stage.scene.width - 20
                        height: bind stage.scene.height - 100
                    },
                    statusBarRef = StatusBar {
                        translateY: bind stage.scene.height - 22
                        width: bind stage.scene.width - 2
                        height: bind 20
                        state: bind model.state;
                    }

                ]

            }
        ]

    }
}


var checkUpdates = Timeline {
    keyFrames: [
        KeyFrame {
            time: 10s
            action: function() {
                /*
                if (model.newFriendUpdates + model.newUserUpdates + model.newReplies + model.newDirectMessages > 0) {
                    alertBox.show(model.newFriendUpdates, model.newUserUpdates, model.newReplies, model.newDirectMessages);
                }
                */
            }
        }
    ]
    repeatCount: java.lang.Double.POSITIVE_INFINITY
};



function run() {
    var controller = FrontController.getInstance();
    controller.start();

    //checkUpdates.play();
}
