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
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.animation.*;

import tweetbox.ui.style.Style;

    /**
     * @author mnankman
     */
    public def defaultHeight:Number = 16;
    public def defaultWidth:Number = 60;

public class Button extends CustomNode {

    public var height:Number = defaultHeight;
    public var width:Number = defaultWidth;

    public var label:String = "button";
    public var imageURL:String;

    public var action:function();

    public var nodeStyle = Style.getApplicationStyle();

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

    public override function create(): Node {
        var textRef:Text;
        return Group {
            content: [
                Rectangle {
                    width: bind width
                    height: bind height
                    arcHeight: bind height / 2
                    arcWidth: bind height / 2
                    fill: nodeStyle.BUTTON_FILL
                    stroke: nodeStyle.BUTTON_STROKE

                    onMouseEntered: function(event) {
                        fade.rate = 1.0;
                        fade.play();
                    }

                    onMouseExited: function(event) {
                        fade.rate = -1.0;
                        fade.play();
                    }

                    onMouseReleased: function(event) {
                        action();
                    }
                },
                Rectangle {
                    blocksMouse: false;
                    width: bind width
                    height: bind height
                    arcHeight: bind height / 2
                    arcWidth: bind height / 2
                    fill: Color.WHITE
                    opacity: bind opacityValue
                }
                textRef = Text {
                    translateX: bind (width - textRef.layoutBounds.width) / 2
                    translateY: bind height / 2 + 5
                    font: bind nodeStyle.BUTTON_TEXT_FONT
                    fill: bind nodeStyle.BUTTON_TEXT_FILL
                    content: bind label
                }

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
                Button {
                    translateX: 50
                    translateY: 100
                    label: "Click me!"
                    action: function() {
                        countClicks++;
                    }
                },
                Text {
                    translateX: 50
                    translateY: 150
                    content: bind "you clicked {countClicks} times on the button"
                }
            ]
        }
    }
}