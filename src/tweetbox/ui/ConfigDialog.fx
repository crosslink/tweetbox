/*
 * ConfigView.fx
 *
 * Created on 2-nov-2008, 23:15:12
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.stage.*;
import javafx.scene.text.Text;

import java.awt.Toolkit;
import java.awt.Dimension;

import org.jfxtras.stage.JFXStage;

import tweetbox.model.Model;
import tweetbox.control.FrontController;
import tweetbox.generic.component.Button;
import tweetbox.generic.component.TabNavigator;
import tweetbox.generic.component.Tab;
import tweetbox.ui.style.Style;
import tweetbox.valueobject.AccountVO;
import tweetbox.generic.component.Button;
import tweetbox.generic.layout.FlowBox;
import tweetbox.configuration.CustomConfigNode;
import tweetbox.generic.component.Dialog;

/**
 * @author mnankman
 */

def height = 300;
def width = 400;

public function create(): Dialog {
    def nodeStyle = bind Style.getApplicationStyle();
    def controller = FrontController.getInstance();
    def model = Model.getInstance();

    var tabs: Tab[];

    def dlg:Dialog = Dialog {
        title: "TweetBox configuration"
        width: width
        height: height

        content: [
            TabNavigator {
                translateX: 10
                width: bind width - 20
                height: bind height - 100
                tabs: tabs = [
                    Tab {
                        label: "Login"
                        node: LoginCredentialsConfigView {
                            width: bind width - 30
                            height: bind height - 25
                            visible:true
                        }

                    },
                    Tab {
                        label: "Twitter API"
                        node: TwitterAPISettingsView {
                            width: bind width - 30
                            height: bind height - 25
                        }

                    },
                    Tab {
                        label: "Tweet options"
                        node: TweetOptionsView {
                            width: bind width - 30
                            height: bind height - 25
                        }
                    },
                    Tab {
                        label: "Appearance"
                        node: AppearanceOptionsView {
                            width: bind width - 30
                            height: bind height - 25
                        }
                    }
                ]

            }
        ]

        buttons: [
            Button {
                label: "OK"
                imageURL: "{__DIR__}icons/accept.png"
                action: function():Void {
                   dlg.close();
                   for (t in tabs) {
                       if (t.node instanceof CustomConfigNode) {
                           var configNode = t.node as CustomConfigNode;
                           configNode.apply();
                       }
                   }
                }
            },

            Button {
                label: "Cancel"
                imageURL: "{__DIR__}icons/cancel.png"
                action: function():Void {
                    dlg.close();
                }
            },
        ]

        onOpen: function() {
            controller.stopReceiving();
        }

        onClose: function() {
            controller.startReceiving();
        }
    }
}

public function run() {
    var dlg = create();

    var scene:Scene = Scene {
        content: [
            Button {
                translateX: 5
                translateY: 5
                width: 150
                label: "Configure TweetBox"
                action: function() {
                     dlg.open(scene);
                }
            }
        ]

    }

    Stage {
        x:50 y:50 width:800 height:500
        onClose: function() {
            java.lang.System.exit(0);
        }
        scene: scene
    }
}

