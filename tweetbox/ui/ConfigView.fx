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
import javafx.ext.swing.SwingComponent;
import javafx.ext.swing.SwingLabel;
import javafx.ext.swing.SwingTextField;
import javax.swing.JPasswordField;
import tweetbox.model.Model;
import com.javafxpert.custom_node.*;
import tweetbox.control.FrontController;
import tweetbox.generic.component.ScrollView;

/**
 * @author mnankman
 */
public class ConfigView extends CustomNode {
    
    public override function create(): Node {
        return Group {
            var controller = FrontController.getInstance();
            var model = Model.getInstance();
            var twitterAccount = controller.getAccount("twitter");
            var loginField:SwingTextField;
            var passwordField:JPasswordField = new JPasswordField(twitterAccount.password, 20);
            content: [
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
                MenuNode {
                    translateX: 30
                    translateY: 100
                    buttons: [
                        ButtonNode {
                            title: "Save"
                            imageURL: "{__DIR__}icons/accept.png"
                            action:
                            function():Void {
                                twitterAccount.password = "{passwordField.getPassword()}";
                                controller.updateAccount(twitterAccount);
                            }
                        }
                    ]
                }
            ]

        };
    }
}
