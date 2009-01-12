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

import com.javafxpert.custom_node.*;

import tweetbox.model.Model;
import tweetbox.model.State;
import tweetbox.ui.style.Style;
import tweetbox.control.FrontController;
import tweetbox.generic.component.ScrollView;

var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();

var nodeStyle = Style.getApplicationStyle();

var deckRef:DeckNode;

var model = Model.getInstance();

var controller = FrontController.getInstance();

var alertBox = AlertBox {
    width: 200
    height: 120
}

var stageOpacityValue:Number = 0.0;

var stageWidth = 800;

var stageHeight = 600;

var stage:Stage = Stage {
    title: "TweetBox"
    opacity: bind stageOpacityValue
    width: bind stageWidth
    height: bind stageHeight
    x: (screenSize.width - stageWidth) / 2
    y: (screenSize.height - stageHeight) / 2
    //style: StageStyle.TRANSPARENT
    resizable: true

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
                var menuRef:MenuNode;
                var configRef:ConfigView;
                var updateRef:UpdateNode;
                var queryRef:QueryNode;
                var statusBarRef:StatusBar;
                content: [
                    Rectangle {
                        stroke: nodeStyle.APPLICATION_BACKGROUND_STROKE
                        x:0 y:0
                        width: bind stage.scene.width - 2
                        height: bind stage.scene.height - 2
                        //arcWidth:20
                        //arcHeight:20
                        fill:nodeStyle.APPLICATION_BACKGROUND_FILL

                    },
                    deckRef = DeckNode {
                        translateX: 3
                        translateY: 30
                        fadeInDur: 0ms
                        content: [
                        // The "Home" page
                            HomeView {
                                translateY: 5
                                width: bind stage.scene.width - 20
                                height: bind stage.scene.height - 130
                                id: "Home"
                            },
                        // The "Config" page
                            Group {
                                id: "Config"
                                content: [
                                    configRef = ConfigView {
                                        translateX: bind stage.scene.width / 2 - configRef.layoutBounds.width / 2
                                        translateY: bind stage.scene.height / 2
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
                                        font: nodeStyle.UPDATE_TEXT_FONT
                                    }
                                ]
                            },
                        // The "Help" page
                            Group {
                                id: "Help"
                                content: [
                                    ScrollView {
                                        height: 200
                                        width: 250
                                        content :[
                                            HTMLNode {
                                                width: 300
                                                html: "<em>emphasized</em><br><strong>bold</strong><br><a href=\"http://www.twitter.com\">link</a>"
                                                font: nodeStyle.UPDATE_TEXT_FONT
                                            },
                                            HTMLNode {
                                                width: 200
                                                html: "Morbi scelerisque eros cursus purus. Aenean felis mauris, tristique vitae, blandit nec, accumsan at, pede. Donec cursus pede ac mi. Fusce elementum consectetuer sapien. Nullam tempus metus in felis. Nunc viverra, risus in gravida rhoncus, erat justo congue augue, non vehicula dui quam in dui. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin at eros. Donec egestas euismod felis. Sed urna arcu, vulputate eu, dictum sit amet, auctor sit amet, sem. Proin pharetra ligula vitae elit. Ut lorem ante, semper vitae, dapibus id, consequat et, magna. "
                                                font: nodeStyle.UPDATE_TEXT_FONT
                                            }
                                        ]

                                    }

                                ]

                            }

                        ]
                    },
                    menuRef = MenuNode {
                        translateX: bind stage.scene.width / 2 - menuRef.layoutBounds.width / 2
                        translateY: bind stage.scene.height - 50
                        buttons: [
                            ButtonNode {
                                title: "Home"
                                imageURL: "{__DIR__}icons/home.png"
                                action:
                                function():Void {
                                    deckRef.visibleNodeId = "Home";
                                }
                            },
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
                                    alertBox.show(0,0,0,0);
                                    deckRef.visibleNodeId = "Help";
                                }
                            }
                        ]
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


var fadeIn = Timeline {
    keyFrames: [
        KeyFrame {
            time:1s
            values: [
                stageOpacityValue => 1.0 tween Interpolator.LINEAR,
             ]
        },
    ]
};

var fadeOut = Timeline {
    keyFrames: [
        KeyFrame { time:1s values:stageOpacityValue => 0.0 tween Interpolator.LINEAR
            action: function() { controller.exit(); }
        },
    ]
};

var checkUpdates = Timeline {
    keyFrames: [
        KeyFrame {
            time: 10s
            action: function() {
                if (model.newFriendUpdates + model.newUserUpdates + model.newReplies + model.newDirectMessages > 0) {
                    alertBox.show(model.newFriendUpdates, model.newUserUpdates, model.newReplies, model.newDirectMessages);
                }
            }
        }
    ]
    repeatCount: java.lang.Double.POSITIVE_INFINITY
};



function run() {
    var controller = FrontController.getInstance();
    controller.start();

    //checkUpdates.play();
    
    if (controller.getAccount("twitter") == null)
        deckRef.visibleNodeId = "Config"
    else
        deckRef.visibleNodeId = "Home";

    //stage.visible = true;
    //fadeIn.play();
}
