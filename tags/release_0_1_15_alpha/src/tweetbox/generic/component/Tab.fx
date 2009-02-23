/*
 * Tab.fx
 *
 * Created on 6-feb-2009, 11:48:23
 */

package tweetbox.generic.component;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.animation.*;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.paint.Color;

import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */

public class Tab extends CustomNode {

    public var label:String;
    public var node:Node;
    public var height:Number = 20;

    public var onTabClicked:function(tab:Tab);

    public var selected:Boolean on replace {
        node.visible = selected;
    }

    var nodeStyle = Style.getApplicationStyle();

    var opacityValue:Number = 0.0;

    public var fade = Timeline {
        keyFrames: [
            KeyFrame {
                time: bind 100ms
                values: [
                    opacityValue => 0.3 tween Interpolator.LINEAR,
                ]
            }
        ]
    };

    var labelNode:Node;

    var tabWidth = bind labelNode.layoutBounds.width + 10;
    var tabHeight = bind height;

    var tabPoints = bind [
        0.0, tabHeight,
        3.0, 0.0,
        tabWidth-3.0, 0.0
        tabWidth, tabHeight
    ];


    var tabShapeNode:Node;

    public override function create(): Node {

        return Group {
            content: [
                tabShapeNode  = Polygon {
                    points: bind tabPoints
                    fill: bind nodeStyle.TAB_FILL
                    stroke: bind nodeStyle.TAB_STROKE

                    onMouseEntered: function(event) {
                        fade.rate = 1.0;
                        fade.play();
                    }

                    onMouseExited: function(event) {
                        fade.rate = -1.0;
                        fade.play();
                    }

                    onMouseReleased: function(event) {
                        onTabClicked(this);
                    }
                },
                Polygon {
                    visible: bind not selected
                    blocksMouse: false;
                    points: bind tabPoints
                    fill: Color.BLACK
                    opacity: 0.2
                },
                Polygon {
                    visible: bind not selected
                    blocksMouse: false;
                    points: bind tabPoints
                    fill: Color.WHITE
                    opacity: bind opacityValue
                },
                labelNode  = Text {
                    translateX: 5
                    translateY: 15
                    content: bind label;
                    fill: nodeStyle.TAB_TEXT_FILL
                    font: nodeStyle.TAB_TEXT_FONT
                }
            ]
        };
    }
}

public function run() {
    Stage {
        x:100 y:300 width:500 height:300
        onClose: function() {
            java.lang.System.exit(0);
        }
        scene:Scene {
            content: [
                Tab {
                    translateX:100
                    translateY:100
                    label: "This is a test tab"
                }
            ]

        }
    }

}