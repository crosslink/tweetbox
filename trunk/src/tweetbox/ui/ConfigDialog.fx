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

/**
 * @author mnankman
 */
public class ConfigDialog extends CustomNode {

    public var title = "TweetBox configuration";
    public-read var width = 400;
    public-read var height = 300;

    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    var nodeStyle = bind Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();

    var tabs:Tab[] = [
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
            node: TwitterAPISettingsView {}
        },
        Tab {
            label: "Tweet options"
            node: TweetOptionsView {}
        }
    ];
    
    var content = Group {
        content: [
            Rectangle {
                cache:true
                translateX:0
                translateY:0
                stroke: bind nodeStyle.DIALOG_STROKE
                strokeWidth: 3
                x:0
                y:0
                width: bind width - 2
                height: bind height - 2
                fill: bind nodeStyle.DIALOG_FILL

            },
            Group {
                content: [
                    Rectangle {
                        x:3
                        y:3
                        width: bind width - 6
                        height: bind 20
                        fill: bind nodeStyle.DIALOG_TITLEBAR_FILL
                    },
                    Text {
                        translateY: 15
                        translateX: 10
                        content: title
                        fill: bind nodeStyle.DIALOG_TITLEBAR_TEXT_FILL
                        font: bind nodeStyle.DIALOG_TITLEBAR_TEXT_FONT
                    }
                ]
            },
            TabNavigator {
                translateX: 10
                translateY: 30
                width: bind width - 20
                height: bind height - 100
                tabs: tabs
            },
            FlowBox {
                width: bind width - 20
                translateX: 10
                translateY: height - 30
                content: [
                    Button {
                        label: "OK"
                        imageURL: "{__DIR__}icons/accept.png"
                        action: function():Void {
                           controller.hideConfigDialog();
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
                            controller.hideConfigDialog();
                        }
                    },
                ]

            }
        ]
    }

    public override function create(): Node {
        return Group {
            content: bind content
        };
    }


}

public function run() {
    var config = ConfigDialog {
        translateY:200
        translateX:100
        visible: bind Model.getInstance().configDialogVisible
    }

    Stage {
        x:100 y:300 width:600 height:600
        onClose: function() {
            java.lang.System.exit(0);
        }
        scene:Scene {
            content: [
                Button {
                    translateX: 5
                    translateY: 5
                    width: 150
                    label: "Configure TweetBox"
                    action: function() {
                         FrontController.getInstance().showConfigDialog();
                    }
                },
                config
            ]

        }
    }
}

