/*
 * TitleBar.fx
 *
 * Created on 8-jan-2009, 22:36:01
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.scene.layout.HBox;

import tweetbox.generic.component.Button;

import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */

public class TitleBar extends CustomNode {

    public var width:Number;
    public var title:String;

    public var buttons:Button[];

    var nodeStyle = Style.getApplicationStyle();

    var buttonBox:HBox = HBox {
        translateY: 5
        translateX: bind (width - buttonBox.layoutBounds.width - 2)
        content: for (btn:Button in buttons) {
            btn
        }
    }

    public override function create(): Node {
        return Group {
            content: [
                Rectangle {
                    x:0
                    y:0
                    width: bind width - 2
                    height: 20
                    fill:nodeStyle.APPLICATION_TITLEBAR_FILL
                },
                Text {
                    translateY: 15
                    translateX: 10
                    content: bind title
                    fill: nodeStyle.APPLICATION_TITLEBAR_TEXT_FILL
                    font: nodeStyle.APPLICATION_TITLEBAR_TEXT_FONT
                },
                buttonBox
            ]
        };
    }
}