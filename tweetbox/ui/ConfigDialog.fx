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
import javafx.stage.Stage;

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

    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    var nodeStyle = Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();
    var twitterAccount:AccountVO = controller.getAccount("twitter");
    var loginField:SwingTextField;
    var passwordField:JPasswordField = new JPasswordField(twitterAccount.password, 20);
    
    var content = Group {
        content: [
            Rectangle {
                stroke: nodeStyle.APPLICATION_BACKGROUND_STROKE
                x:0 y:0
                width: bind width
                height: bind height
                fill:nodeStyle.APPLICATION_BACKGROUND_FILL
            },
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
                            visible = false;
                        }
                    },

                    Button {
                        label: "Cancel"
                        imageURL: "{__DIR__}icons/cancel.png"
                        action: function():Void {
                            visible = false;
                        }
                    },
                ]

            }
        ]
    }

    public var stage:JFXStage = JFXStage {
        alwaysOnTop: true
        x: bind (screenSize.width - width) / 2
        y: bind (screenSize.height - height) / 2
        title: "TweetBox Alert"
        width: width
        height: height
        resizable: false
        visible: bind visible;
        scene: Scene {
            content: bind content
        }

    };

}
