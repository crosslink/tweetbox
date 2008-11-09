/*
 * ConfigView.fx
 *
 * Created on 2-nov-2008, 23:15:12
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.layout.*;
import javafx.ext.swing.ComponentView;
import javafx.ext.swing.Component;
import javafx.ext.swing.Label;
import javafx.ext.swing.TextField;
import javax.swing.JPasswordField;
import tweetbox.model.Model;
import com.javafxpert.custom_node.*;
import tweetbox.control.FrontController;

/**
 * @author mnankman
 */
public class ConfigView extends CustomNode {
    
    public function create(): Node {
        return Group {
            var controller = FrontController.getInstance();
            var model = Model.getInstance();
            var twitterAccount = controller.getAccount("twitter");
            var loginField:TextField;
            var passwordField:JPasswordField = new JPasswordField(twitterAccount.password, 20);
            content: [
                ComponentView {
                    translateX: 10
                    translateY: 10
                    component: Label {
                        text: "login: "
                    }
                },       
                ComponentView {
                    translateX: 100
                    translateY: 10
                    component: 
                    loginField = TextField {
                        columns: 20
                        text: twitterAccount.login
                    }

                },
                ComponentView {
                    translateX: 10
                    translateY: 40
                    component: Label {
                        text: "password: "
                    }
                },                                    
                ComponentView {
                    translateX: 100
                    translateY: 40
                    component: Component.fromJComponent(passwordField)

                },
                MenuNode {
                    translateX: 30
                    translateY: 100
                    buttons: [
                        ButtonNode {
                            title: "Save"
                            imageURL: "{__DIR__}icons/accept.png"
                            action:
                            function():Void {
                                twitterAccount.password = passwordField.getText();
                                controller.updateAccount(twitterAccount);
                                controller.getTweets();
                            }
                        }
                    ]
                }
            ]

        };
    }
}
