/*
 * TweetsView.fx
 *
 * Created on 31-okt-2008, 9:33:30
 */

package tweetbox.generic.component;

import javafx.input.*;
import javafx.scene.*;
import javafx.scene.geometry.*;
import javafx.scene.transform.*;
import javafx.scene.effect.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
import com.javafxpert.custom_node.TableNode;
import tweetbox.model.*;
import javafx.scene.text.*;
import javafx.scene.image.*;
import javafx.ext.swing.*;
import java.lang.System;
import java.util.List;
import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */
public class ScrollView extends CustomNode {

  /*
   * Contains the height of the view in pixels.
   */
    public attribute height:Integer;

  /*
   * Contains the width of the view in pixels.
   */
    public attribute width:Integer;

    private attribute style = Style.getApplicationStyle();

  /*
   * The color or gradient of the vertical scrollbar.
   */
    private attribute vertScrollbarFill:Paint = style.SCROLLBAR_TRACK_FILL;
   
  /*
   * The color or gradient of the vertical scrollbar thumb.
   */
    private attribute vertScrollbarThumbFill:Paint = style.SCROLLBAR_THUMB_FILL;
   
  /*
   * The width (in pixels) of the vertical scrollbar.
   */
    public attribute vertScrollbarWidth:Integer = 20;

    public attribute scrollStepSize:Integer = 5;
    
    public attribute content: Node[];
    
    public function create(): Node {
        return Group {
            var needScrollbar:Boolean = true;
            var thumbStartY = 0.0;
            var thumbEndY = 0.0;
            var thumb:Rectangle;
            var track:Rectangle;
            var contentContainerRef:VBox;
            var scrollBarRef:Group;
            blocksMouse:true
            content: [
                contentContainerRef = VBox {
                    transform: bind Translate.translate(0, -1.0 * thumbEndY * contentContainerRef.getBoundsHeight() / track.getHeight())
                    content: bind for (node:Node in content) {node}
                },
                if (needScrollbar)
                    scrollBarRef = Group {
                        transform: bind Translate.translate(width - vertScrollbarWidth, 0)
                        content: [
                            track = Rectangle {
                                x: 0
                                y: 0
                                width: vertScrollbarWidth
                                height: bind height
                                arcHeight: 25
                                arcWidth: 25
                                fill: vertScrollbarFill
                            },
                            //Scrollbar thumb
                            thumb = Rectangle {
                                blocksMouse:true
                                x: 0
                                y: bind thumbEndY
                                width: vertScrollbarWidth
                                height: bind track.getHeight() / (contentContainerRef.getBoundsHeight()) * track.getHeight()
                                fill: vertScrollbarThumbFill
                                arcHeight: 25
                                arcWidth: 25
                                onMousePressed: function(e:MouseEvent):Void { 
                                    thumbStartY = e.getDragY() - thumbEndY; 
                                } 
                                onMouseDragged: function(e:MouseEvent):Void {
                                    var tempY = e.getDragY() - thumbStartY;
                                    // Keep the scroll thumb within the bounds of the scrollbar
                                    if (tempY >= 0 and tempY + thumb.getHeight() <= track.getHeight()) {
                                        thumbEndY = tempY; 
                                    }
                                    else if (tempY < 0) {
                                        thumbEndY = 0;
                                    }
                                    else {
                                        thumbEndY = track.getHeight() - thumb.getHeight();
                                    }
                                }
                                onMouseDragged: function(e:MouseEvent):Void {
                                    var tempY = e.getDragY() - thumbStartY;
                                    // Keep the scroll thumb within the bounds of the scrollbar
                                    if (tempY >= 0 and tempY + thumb.getHeight() <= track.getHeight()) {
                                        thumbEndY = tempY; 
                                    }
                                    else if (tempY < 0) {
                                        thumbEndY = 0;
                                    }
                                    else {
                                        thumbEndY = track.getHeight() - thumb.getHeight();
                                    }
                                }
                            }
                        ]
                    } 
                else
                    null
            ]
            clip:
                Rectangle {
                    width: bind width
                    height: bind height
                }
                
            onMouseWheelMoved: function(e:MouseEvent):Void {
                var tempY = thumbEndY + e.getWheelRotation() * scrollStepSize;
                // Keep the scroll thumb within the bounds of the scrollbar
                if (tempY >= 0 and tempY + thumb.getHeight() <= track.getHeight()) {
                    thumbEndY = tempY; 
                }
                else if (tempY < 0) {
                    thumbEndY = 0;
                }
                else {
                    thumbEndY = track.getHeight() - thumb.getHeight();
                }
            }
        };
    }
}