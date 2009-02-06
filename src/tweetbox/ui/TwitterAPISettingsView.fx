/*
 * TwitterAPISettingsView.fx
 *
 * Created on 6-feb-2009, 15:24:16
 */

package tweetbox.ui;

import javafx.scene.Group;
import javafx.scene.Node;

import tweetbox.ui.style.Style;
import tweetbox.model.Model;
import tweetbox.control.FrontController;
import tweetbox.generic.component.Button;
import tweetbox.generic.layout.FlowBox;
import tweetbox.configuration.CustomConfigNode;


/**
 * @author mnankman
 */

public class TwitterAPISettingsView extends CustomConfigNode {

    var nodeStyle = Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();

    public override function apply(): Void {
    }

    public override function create(): Node {
        return Group {
            content: []
        };
    }
}