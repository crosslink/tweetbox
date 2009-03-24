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

import tweetbox.generic.component.ListBox;


/**
 * @author mnankman
 */

public class AppearanceOptionsView extends CustomConfigNode {

    var nodeStyle = bind Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();

    var themeCellRenderer = ThemeCellRenderer{}

    var selectedThemeExample:Node = themeCellRenderer.create(nodeStyle, this.layoutBounds);

    public override function apply(): Void {
    }

    public override function create(): Node {
        return Group {
            content: [
                ListBox {
                    translateY: 5
                    translateX: 10
                    model: model.themes;
                    cellHeight: 70
                    height: 160
                    width: 70
                    cellRenderer: themeCellRenderer
                }
            ]
        };
    }
}