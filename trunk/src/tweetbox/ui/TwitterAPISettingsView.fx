/*
 * TwitterAPISettingsView.fx
 *
 * Created on 6-feb-2009, 15:24:16
 */

package tweetbox.ui;

import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.text.Text;

import tweetbox.ui.style.Style;
import tweetbox.model.Model;
import tweetbox.control.FrontController;
import tweetbox.configuration.CustomConfigNode;


/**
 * @author mnankman
 */

public class TwitterAPISettingsView extends CustomConfigNode {

    var nodeStyle = bind Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();

    public override function apply(): Void {
    }

    public override function create(): Node {
        return Group {
            content: [
                Text {
                    translateX: 20
                    translateY: 40
                    content: "under construction"
                    fill: bind nodeStyle.DIALOG_TEXT_FILL
                    font: bind nodeStyle.DIALOG_TEXT_FONT
                }
            ]
        };
    }
}