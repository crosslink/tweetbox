/*
 * Balloon.fx
 *
 * Created on 25-mrt-2009, 13:13:58
 */

package tweetbox.generic.component;

import java.lang.Math;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.ShapeSubtract;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Line;
import javafx.scene.paint.Paint;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;

import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */

public class Balloon extends CustomNode {

    public var content: Node;

    /** the x-coordinate of the top left corner of the balloon */
    public var x:Number;

    /** the y-coordinate of the top left corner of the balloon */
    public var y:Number;

    /** the x-coordinate of the point the balloon points to */
    public var toX:Number;

    /** the y-coordinate of the point the balloon points to */
    public var toY:Number;

    /** the fill color of the balloon */
    public var fill:Paint = Color.LIGHTYELLOW;

    /** the stroke color of the balloon */
    public var stroke:Paint = Color.BLACK;

    // calculated dimensions of the balloon
    var width:Integer = bind content.layoutBounds.width + 20;
    var height:Integer = bind content.layoutBounds.height + 20;

    //the calculated center of the balloon
    var cX = bind x + width/2;
    var cY = bind y + height/2;

    public override function create(): Node {
        return Group {
            content: [
                Group {
                    content: [
                        ShapeSubtract {
                            fill: bind fill
                            stroke: bind stroke
                            a: [
                                Rectangle {
                                    x: bind x
                                    y: bind y
                                    width: bind width
                                    height: bind height
                                    arcHeight: 20
                                    arcWidth: 20
                                },
                                Polygon {
                                    points: bind [
                                        cX-20, cY,
                                        cX+20, cY,
                                        toX, toY
                                    ]
                                }
                            ]
                        },
                        Group {
                            translateY: bind y+10
                            translateX: bind x+10
                            content: bind [content]
                        },
                    ]
                }
            ]

        };
    }
}


// -- Test Code --

import javafx.scene.Scene;
import javafx.stage.Stage;

public function run() {
    def stage = Stage {
        x: 100
        y: 100
        width: 800
        height: 400
        scene: Scene {
            content: [
                Balloon {
                    x: 400
                    y: 20
                    toX: 400
                    toY: 0
                    content: Text {
                        content: "Test Balloon 1"
                    }
                },
                Balloon {
                    x: 0
                    y: 100
                    toX: 100
                    toY: 300
                    content: Text {
                        content: "Test Balloon 2"
                    }
                },
            ]

        }
    }
}