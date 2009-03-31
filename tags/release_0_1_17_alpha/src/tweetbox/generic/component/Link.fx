/*
 * Button.fx
 *
 * Created on 15-jan-2009, 10:35:25
 */

package tweetbox.generic.component;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.text.Text;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Line;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.animation.*;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.Cursor;

import tweetbox.ui.style.Style;
import tweetbox.util.BrowserLauncher;

/**
 * @author mnankman
 */

public class Link extends CustomNode {

    public var label:String = "";
    public var url:String = "";

    public var nodeStyle = bind Style.getApplicationStyle();

    var labelNode:Node = Text {
        translateY: bind nodeStyle.BUTTON_TEXT_FONT.size
        translateX: 1
        font: bind nodeStyle.BUTTON_TEXT_FONT
        fill: Color.BLUE
        content: bind label
    };

    var mouseOver:Boolean = false;

    protected function action() {
        BrowserLauncher.openURL(url.trim());
    }

    public override function create(): Node {
        var textRef:Text;
        return Group {
            content: [
                Rectangle {
                    width: bind labelNode.layoutBounds.width
                    height: bind labelNode.layoutBounds.height
                    fill: Color.TRANSPARENT
                    stroke: Color.TRANSPARENT
                    cursor: Cursor.HAND
                    onMouseEntered: function(event) {
                        mouseOver = true;
                    }

                    onMouseExited: function(event) {
                        mouseOver = false;
                    }

                    onMouseReleased: function(event) {
                        action();
                    }
                },
                Line {
                    startX:0
                    endX:bind labelNode.layoutBounds.width
                    startY: bind labelNode.layoutBounds.height
                    endY: bind labelNode.layoutBounds.height
                    stroke: Color.BLUE
                    visible: bind mouseOver
                }
                labelNode
            ]

        };
    }
}

function run(): Void {
    var countClicks:Integer = 0;
    Stage {
        width: 400
        height: 400
        scene: Scene {
            fill: Color.WHITE
            content: [
                Link {
                    label: "Click me!"
                    url: "http://www.tweetbox.org"
                }
            ]
        }
    }
}