
/*
 *  ProgressNode.fx - 
 *  A custom node that functions as a progress bar
 *  TODO: Add the ability to have an "infinite progress" look as well
 *
 *  Developed 2008 by James L. Weaver (jim.weaver at lat-inc.com)
 *  to demonstrate how to create custom nodes in JavaFX
 */

package com.javafxpert.custom_node;
 
import javafx.scene.*;
import javafx.scene.geometry.*;
import javafx.scene.paint.*;
import javafx.scene.text.*;

public class ProgressNode extends CustomNode { 

  /*
   * A number from 0.0 to 1.0 that indicates the amount of progress
   */
    public attribute progress:Number;
    
  /*
   * The fill of the progress part of the progress bar.  Because
   * this is of type Paint, a Color or gradient may be used.
   */
    public attribute progressFill:Paint = Color.BLUE;
    
  /*
   * The fill of the bar part of the progress bar. Because
   * this is of type Paint, a Color or gradient may be used.
   */
    public attribute barFill:Paint = Color.GREY;
    
  /*
   * The color of the progress percent text on the progress bar
   */
    public attribute progressPercentColor:Color = Color.WHITE;
    
  /*
   * The color of the progress text on the right side of the progress bar
   */
    public attribute progressTextColor:Color = Color.WHITE;
    
  /*
   * The progress text string on the right side of the progress bar
   */
    public attribute progressText:String;
    
  /*
   * Determines the width, in pixels, of the progress bar
   */
    public attribute width:Integer = 200;
    
  /*
   * Determines the height, in pixels, of the progress bar
   */
    public attribute height:Integer = 20;
    
  /**
   * Create the Node
   */
    public function create():Node {
        Group {
            var textRef:Text;
            var progTextRef:Text;
            var progBarFont =
            Font {
                name: "Sans serif"
                style: FontStyle.BOLD
                size: 12 
            };
            content: [
        // The entire progress bar
                Rectangle {
                    width: bind width
                    height: bind height
                    fill: bind barFill
                },
        // The progress part of the progress bar
                Polygon {
                    points: bind [
                        0.0, 0.0,
                        0.0, height as Number,
            width * progress + height / 2.0, height as Number,
            width * progress - height / 2.0, 0.0
                    ]
                    fill: bind progressFill
                    clip:
                        Rectangle {
                            width: bind width
                            height: bind height
                        }
                },
        // The percent complete displayed on the progress bar
                textRef = Text {
                    translateX: width / 3
                    translateY: 3
                    textOrigin: TextOrigin.TOP
                    font: progBarFont
                    fill: bind progressPercentColor
                    content: bind "{
                    progress * 100 as Integer}%"
                },
        // The progress text displayed on the right side of the progress bar
                progTextRef = Text {
                    translateX: bind width - progTextRef.getWidth() - 5
                    translateY: 3
                    textOrigin: TextOrigin.TOP
                    font: progBarFont
                    fill: bind progressTextColor
                    content: bind progressText
                }
            ]
        }    
    }
}