/*
 * Icon.fx
 *
 * Created on 7-mrt-2009, 15:32:17
 */

package tweetbox.generic.component;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.text.Text;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.animation.*;
import javafx.scene.Cursor;

import tweetbox.ui.style.Style;


/**
 * @author mnankman
 */
public def defaultHeight:Number = 14;
public def defaultWidth:Number = 14;

public class Icon extends CustomNode {

    public var height:Number = defaultHeight;
    public var width:Number = defaultWidth;

    public var label:String = "";
    public var imageURL:String;

    public var action:function();

    public var nodeStyle = Style.getApplicationStyle();

    var opacityValue:Number = 0.0;
    public var fade = Timeline {
        keyFrames: [
            KeyFrame {
                time: bind 100ms
                values: [
                    opacityValue => 1.0 tween Interpolator.LINEAR,
                ]
            }
        ]
    };
    public override function create(): Node {
        var textRef:Text;
        var imageRef:ImageView;
        return Group {
            translateY:-10
            content: [
                Rectangle {
                    width: bind width
                    height: bind height
                    arcHeight: bind height / 2
                    arcWidth: bind height / 2
                    fill: nodeStyle.BUTTON_FILL
                    stroke: nodeStyle.BUTTON_STROKE
                    opacity: bind opacityValue
                },
                imageRef = ImageView {
                    cursor: Cursor.HAND
                    blocksMouse: true;
                    fitHeight: height
                    preserveRatio: true
                    image: Image {
                        url: imageURL
                    }
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
                Icon {
                    translateX: 50
                    translateY: 100
                    label: "Click me!"
                    imageURL: "{__DIR__}accept.png"
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