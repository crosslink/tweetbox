/*
 * LoginCredentialsConfigView.fx
 *
 * Created on 6-feb-2009, 14:49:42
 */

package tweetbox.ui;

import javafx.scene.Group;
import javafx.scene.Node;
import javafx.ext.swing.SwingComponent;
import javafx.ext.swing.SwingLabel;
import javafx.ext.swing.SwingTextField;
import javafx.stage.*;
import javafx.scene.text.Text;

import javax.swing.JPasswordField;

import tweetbox.ui.style.Style;
import tweetbox.valueobject.AccountVO;
import tweetbox.model.Model;
import tweetbox.control.FrontController;
import tweetbox.configuration.CustomConfigNode;

/**
 * @author mnankman
 */

public class LoginCredentialsConfigView extends CustomConfigNode {

    public var width;
    public var height;

    var nodeStyle = Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();
    var twitterAccount:AccountVO = controller.getAccount("twitter");
    var loginField:SwingTextField;
    var passwordField:JPasswordField = new JPasswordField(twitterAccount.password, 20);

    public override var visible = false on replace {
        if (visible) {
            loginField.text = twitterAccount.login;
            passwordField.setText(twitterAccount.password);
        }
    };

    public override function apply(): Void {
        controller.updateAccount(
            AccountVO {
                id: "twitter"
                login: loginField.text
                password: new String(passwordField.getPassword())
            }
        );
    }

    public override function create(): Node {
        return Group {
            translateY: 40
            content: [
                Text {
                    translateX: 10
                    translateY: 10
                    fill: nodeStyle.DIALOG_TEXT_FILL
                    font: nodeStyle.DIALOG_TEXT_FONT
                    content: "login: "
                },
                loginField = SwingTextField {
                    translateX: 100
                    translateY: 10
                    columns: 20
                    text: twitterAccount.login
                },
                Text {
                    translateX: 10
                    translateY: 40
                    fill: nodeStyle.DIALOG_TEXT_FILL
                    font: nodeStyle.DIALOG_TEXT_FONT
                    content: "password: "
                },
                Group {
                    translateX: 100
                    translateY: 40
                    content: SwingComponent.wrap(passwordField)

                },
            ]
        };
    }
}