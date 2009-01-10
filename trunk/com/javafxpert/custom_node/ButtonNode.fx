/*
 *  ButtonNode.fx -
 *  A node that functions as an image button
 *
 *  Developed 2008 by James L. Weaver (jim.weaver at javafxpert.com)
 *  and Edgar Merino (http://devpower.blogsite.org/) to demonstrate how
 *  to create custom nodes in JavaFX
 */

package com.javafxpert.custom_node;

import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.input.MouseEvent;
import javafx.scene.effect.Glow;
import javafx.scene.shape.Rectangle;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;

public class ButtonNode extends CustomNode {
    /**
    * The title for this button
     */
    public var title:String;

    /**
    * The Image for this button
     */
    var btnImage:Image;

    /**
    * The URL of the image on the button
     */
    public var imageURL:String on replace {
        btnImage =
        Image {
            url: imageURL
        };
  }

    /**
    * The percent of the original image size to show when mouse isn't
     * rolling over it.
     * Note: The image will be its original size when it's being
     * rolled over.
     */
    public var scale:Number = 0.9;

    /**
    * The opacity of the button when not in a rollover state
     */
    public var opacityValue:Number = 0.8;

    /**
    * The opacity of the text when not in a rollover state
     */
    public var textOpacityValue:Number = 0.0;

    /**
    * A Timeline to control fading behavior when mouse enters or exits a button
     */
    public var fadeTimeline =
    Timeline {
        keyFrames: [
            KeyFrame {
                time: 500ms
                values: [
                    scale => 1.0 tween Interpolator.LINEAR,
                    opacityValue => 1.0 tween Interpolator.LINEAR,
                    textOpacityValue => 1.0 tween Interpolator.LINEAR
                ]
            }
        ]
    };

    /**
    * This attribute is interpolated by a Timeline, and various
     * attributes are bound to it for fade-in behaviors
     */
    var fade:Number = 1.0;

    /**
    * This attribute represents the state of whether the mouse is inside
     * or outside the button, and is used to help compute opacity values
     * for fade-in and fade-out behavior.
     */
    var mouseInside:Boolean;

    /**
    * The action function attribute that is executed when the
     * the button is pressed
     */
    public var action:function():Void;

    /**
    * Create the Node
     */
    public override function create():Node {
        Group {
            var textRef:Text;
            content: [
                Rectangle {
                    width: bind btnImage.width
                    height: bind btnImage.height
                    opacity: 0.0
                },
                ImageView {
                    image: btnImage
                    opacity: bind opacityValue;
                    scaleX: bind scale;
                    scaleY: bind scale;
                    translateX: bind btnImage.width / 2 - btnImage.width * scale / 2
                    translateY: bind btnImage.height - btnImage.height * scale
                    onMouseEntered: function(me:MouseEvent):Void {
                        mouseInside = true;
                        fadeTimeline.rate = 1.0;
                        fadeTimeline.play();
                    }
                    onMouseExited: function(me:MouseEvent):Void {
                        mouseInside = false;
                        fadeTimeline.rate = -1.0;
                        fadeTimeline.play();
                        me.node.effect = null
                    }
                    onMousePressed: function(me:MouseEvent):Void {
                        me.node.effect = Glow {
                            level: 0.9
                        };
                    }
                    onMouseReleased: function(me:MouseEvent):Void {
                        me.node.effect = null;
                    }
                    onMouseClicked: function(me:MouseEvent):Void {
                        action();
                    }
                },
                textRef = Text {
                    translateX: bind btnImage.width / 2 - textRef.boundsInLocal.width / 2
                    translateY: bind btnImage.height - textRef.boundsInLocal.height
                    textOrigin: TextOrigin.TOP
                    content: title
                    fill: Color.BLACK
                    opacity: bind textOpacityValue
                    font: Font.font("Sans serif", FontWeight.BOLD, 12)
                },
            ]
    };
    }
}