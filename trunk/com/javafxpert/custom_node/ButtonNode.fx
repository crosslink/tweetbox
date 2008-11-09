
/*
 *  ButtonNode.fx - 
 *  A node that functions as an image button
 *
 *  Developed 2008 by James L. Weaver (jim.weaver at lat-inc.com)
 *  and Edgar Merino (http://devpower.blogsite.org/) to demonstrate how 
 *  to create custom nodes in JavaFX
 */

package com.javafxpert.custom_node;
 
import javafx.animation.*;
import javafx.input.*;
import javafx.scene.*;
import javafx.scene.effect.*;
import javafx.scene.geometry.*;
import javafx.scene.image.*;
import javafx.scene.paint.*;
import javafx.scene.text.*;
import javafx.scene.transform.*;

public class ButtonNode extends CustomNode { 
  /**
   * The title for this button
   */
    public attribute title:String;

  /**
   * The Image for this button
   */
    private attribute btnImage:Image;

  /**
   * The URL of the image on the button
   */
    public attribute imageURL:String on replace {
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
    public attribute scale:Number = 1.0;

  /**
   * The opacity of the button when not in a rollover state
   */
    public attribute opacityValue:Number = 0.8;

  /**
   * The opacity of the text when not in a rollover state
   */
    public attribute textOpacityValue:Number = 0.0;

  /**
   * A Timeline to control fading behavior when mouse enters or exits a button
   */
    private attribute fadeTimeline =
    Timeline {
        toggle: true
        keyFrames: [
            KeyFrame {
                time: 600ms
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
    private attribute fade:Number = 1.0;
  
  /**
   * This attribute represents the state of whether the mouse is inside
   * or outside the button, and is used to help compute opacity values
   * for fade-in and fade-out behavior.
   */
    private attribute mouseInside:Boolean;

  /**
   * The action function attribute that is executed when the
   * the button is pressed
   */
    public attribute action:function():Void;
   
  /**
   * Create the Node
   */
    public function create():Node {
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
                    onMouseEntered:
                    function(me:MouseEvent):Void {
                        mouseInside = true;
                        fadeTimeline.start();
                    }
                    onMouseExited:
                    function(me:MouseEvent):Void {
                        mouseInside = false;
                        fadeTimeline.start();
                        me.node.effect = null
                    }
                    onMousePressed:
                    function(me:MouseEvent):Void {
                        me.node.effect = Glow {
                            level: 0.9
                        };
                    }
                    onMouseReleased:
                    function(me:MouseEvent):Void {
                        me.node.effect = null;
                    }
                    onMouseClicked:
                    function(me:MouseEvent):Void {
                        action();
                    }
                },
                textRef = Text {
                    translateX: bind btnImage.width / 2 - textRef.getWidth() / 2
                    translateY: bind btnImage.height - textRef.getHeight() 
                    textOrigin: TextOrigin.TOP
                    content: title
                    fill: Color.BLACK
                    opacity: bind textOpacityValue
                    font:
                    Font {
                        name: "Sans serif"
                        size: 11
                        style: FontStyle.BOLD
                    }
                },
            ]
        };
    }
}