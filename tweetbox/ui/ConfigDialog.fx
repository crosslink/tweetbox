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

import javax.swing.JPasswordField;

import org.jfxtras.stage.JFXDialog;

import tweetbox.model.Model;
import tweetbox.control.FrontController;
import tweetbox.generic.component.Button;
import tweetbox.ui.layout.FlowBox;
import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */
public class ConfigDialog extends JFXDialog {
    
    override var title = "TweetBox configuration";
    override var width = 400;
    override var height = 300;
    override var visible = false;
    override var modal = true;

    var nodeStyle = Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();
    var twitterAccount = controller.getAccount("twitter");
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
            SwingTextField {
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
                            twitterAccount.password = "{passwordField.getPassword()}";
                            controller.updateAccount(twitterAccount);
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

    init {
        scene = Scene {
            content: content
        }
    }
}
