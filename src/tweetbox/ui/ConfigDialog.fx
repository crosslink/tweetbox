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
import javafx.ext.swing.SwingComponent;
import javafx.ext.swing.SwingLabel;
import javafx.ext.swing.SwingTextField;
import javafx.stage.*;
import javafx.scene.text.Text;

import javax.swing.JPasswordField;

import java.awt.Toolkit;
import java.awt.Dimension;

import org.jfxtras.stage.JFXStage;

import tweetbox.model.Model;
import tweetbox.control.FrontController;
import tweetbox.generic.component.Button;
import tweetbox.generic.layout.FlowBox;
import tweetbox.ui.style.Style;
import tweetbox.valueobject.AccountVO;

/**
 * @author mnankman
 */
public class ConfigDialog {
    
    public var title = "TweetBox configuration";
    public var width = 400;
    public var height = 300;
    public var visible = false on replace {
        if (visible) {
            loginField.text = twitterAccount.login;
            passwordField.setText(twitterAccount.password);
        }
    };
    public var modal = false;

    var nodeStyle = Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();
    var twitterAccount:AccountVO = controller.getAccount("twitter");
    var loginField:SwingTextField;
    var passwordField:JPasswordField = new JPasswordField(twitterAccount.password, 20);
    
    var content = Group {
        content: [
            Rectangle {
                translateX:0
                translateY:0
                stroke: nodeStyle.APPLICATION_BACKGROUND_STROKE
                strokeWidth: 3
                x:0
                y:0
                width: bind width - 2
                height: bind height - 2
                fill:nodeStyle.APPLICATION_BACKGROUND_FILL

            },
            Group {
                content: [
                    Rectangle {
                        x:3
                        y:3
                        width: bind width - 6
                        height: bind 20
                        fill:nodeStyle.APPLICATION_TITLEBAR_FILL
                    },
                    Text {
                        translateY: 15
                        translateX: 10
                        content: "TweetBox configuration"
                        fill: nodeStyle.APPLICATION_TITLEBAR_TEXT_FILL
                        font: nodeStyle.APPLICATION_TITLEBAR_TEXT_FONT
                    }
                ]
            },
            Group {
                translateY: 40
                content: [
                    SwingLabel {
                        translateX: 10
                        translateY: 10
                        text: "login: "
                    },
                    loginField = SwingTextField {
                        translateX: 100
                        translateY: 10
                        columns: 20
                        text: twitterAccount.login
                    },
                    SwingLabel {
                        translateX: 10
                        translateY: 40
                        text: "password: "
                    },
                    Group {
                        translateX: 100
                        translateY: 40
                        content: SwingComponent.wrap(passwordField)

                    },
                    FlowBox {
                        width: bind width - 20
                        translateX: 10
                        translateY: 80
                        content: [
                            Button {
                                label: "Save"
                                imageURL: "{__DIR__}icons/accept.png"
                                action: function():Void {
                                    controller.updateAccount(
                                    AccountVO {
                                        id: "twitter"
                                        login: loginField.text
                                        password: new String(passwordField.getPassword())
                                    }
                                    );
                                    controller.hideConfigDialog();
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
        ]
    }

    public var stage:JFXStage = JFXStage {
        alwaysOnTop: true
        x: bind (model.config.applicationStage.width - width) / 2
        y: bind (model.config.applicationStage.height - height) / 2
        title: "TweetBox Alert"
        width: width
        height: height
        style: StageStyle.TRANSPARENT
        resizable: false
        visible: bind visible;
        scene: Scene {
            content: bind content
        }

    };

}

public function run() {
    var config = ConfigDialog {}
    Stage {
        x:100 y:300 width:500 height:300
        onClose: function() {
            java.lang.System.exit(0);
        }
        scene:Scene {
            content: [
                Button {
                    translateX: 100
                    translateY: 100
                    width: 100
                    label: "Configure TweetBox"
                    action: function() {
                         FrontController.getInstance().showConfigDialog();
                    }
                }
            ]

        }
    }
}

