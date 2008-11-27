/*
 * TweetsView.fx
 *
 * Created on 31-okt-2008, 9:33:30
 */

package tweetbox.generic.component;

import javafx.input.*;
import javafx.scene.*;
import javafx.scene.geometry.*;
import javafx.animation.*;
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
    public attribute vertScrollbarWidth:Integer = 14;

    public attribute scrollStepSize:Integer = 5;
    
    public attribute content: Node[];
    
    private attribute thumbStartY = 0.0;
    private attribute thumbEndY = 0.0;
    private attribute scrollValue = 0.0;
    private attribute thumb:Rectangle;
    private attribute track:Rectangle;
    private attribute scrollUpBtn:Rectangle;
    private attribute scrollDownBtn:Rectangle;
    
    public function create(): Node {
        return Group {
            var contentContainerRef:VBox;
            var scrollBarRef:Group;
            blocksMouse:true
            content: [
                contentContainerRef = VBox {
                    transform: bind Translate.translate(0, -1.0 * thumbEndY * contentContainerRef.getBoundsHeight() / track.getHeight())
                    content: bind for (node:Node in content) {node}
                },
                scrollBarRef = Group {
                    visible: bind (contentContainerRef.getHeight() > height)
                    transform: bind Translate.translate(width - vertScrollbarWidth, 0)
                    content: [
                        // scroll button "up"
                        Group {
                            content: [
                                scrollUpBtn = Rectangle {
                                    blocksMouse:true
                                    x: 0
                                    y: 0
                                    width: bind vertScrollbarWidth
                                    height: bind vertScrollbarWidth
                                    arcHeight: bind vertScrollbarWidth/2
                                    arcWidth: bind vertScrollbarWidth/2
                                    fill: bind vertScrollbarThumbFill

                                    onMousePressed: function(e:MouseEvent):Void { 
                                        scrollDown.stop(); 
                                        scrollUp.start(); 
                                    } 
                                    onMouseReleased: function(e:MouseEvent):Void { 
                                        scrollDown.stop(); 
                                        scrollUp.stop(); 
                                    } 
                                    onMouseClicked: function(e:MouseEvent):Void { 
                                        scrollDown.stop(); 
                                        scrollUp.stop(); 
                                        scrollBy(0 - scrollStepSize);
                                    } 
                                },
                                Polyline { 
                                    blocksMouse:false
                                    fill: bind vertScrollbarFill
                                    points: bind [
                                        1.0 * vertScrollbarWidth / 2, 1.0 * vertScrollbarWidth / 4, 
                                        1.0 * vertScrollbarWidth / 4, 3.0 * vertScrollbarWidth / 4,
                                        3.0 * vertScrollbarWidth / 4, 3.0 * vertScrollbarWidth / 4
                                    ]
                                }
                            ]
                        },

                        // scroll button "down"
                        Group {
                            translateY:bind height - vertScrollbarWidth
                            content: [
                                scrollDownBtn = Rectangle {
                                    blocksMouse:true
                                    x: 0
                                    y: 0
                                    width: bind vertScrollbarWidth
                                    height: bind vertScrollbarWidth
                                    arcHeight: bind vertScrollbarWidth/2
                                    arcWidth: bind vertScrollbarWidth/2
                                    fill: bind vertScrollbarThumbFill

                                    onMousePressed: function(e:MouseEvent):Void { 
                                        scrollUp.stop(); 
                                        scrollDown.start(); 
                                    } 
                                    onMouseReleased: function(e:MouseEvent):Void { 
                                        scrollUp.stop(); 
                                        scrollDown.stop(); 
                                    } 
                                    onMouseClicked: function(e:MouseEvent):Void { 
                                        scrollDown.stop(); 
                                        scrollUp.stop(); 
                                        scrollBy(scrollStepSize);
                                    } 
                                },
                                Polyline { 
                                    rotate: 180
                                    translateX: vertScrollbarWidth
                                    translateY: vertScrollbarWidth
                                    blocksMouse:false
                                    fill: bind vertScrollbarFill
                                    points: bind [
                                        1.0 * vertScrollbarWidth / 2, 1.0 * vertScrollbarWidth / 4, 
                                        1.0 * vertScrollbarWidth / 4, 3.0 * vertScrollbarWidth / 4,
                                        3.0 * vertScrollbarWidth / 4, 3.0 * vertScrollbarWidth / 4
                                    ]
                                }
                            ]

                        },

                        // track + thumb
                        Group {
                            translateY: bind scrollUpBtn.getHeight()
                            content: [
                                track = Rectangle {
                                    x: 0
                                    y: 0
                                    width: bind vertScrollbarWidth
                                    height: bind height - scrollDownBtn.getHeight() - scrollUpBtn.getHeight() 
                                    arcHeight: bind vertScrollbarWidth/2
                                    arcWidth: bind vertScrollbarWidth/2
                                    fill: bind vertScrollbarFill
                               },
                                //Scrollbar thumb
                                thumb = Rectangle {
                                    blocksMouse:true
                                    x: 0
                                    y: bind thumbEndY
                                    width: vertScrollbarWidth
                                    height: bind (track.getHeight() / (contentContainerRef.getBoundsHeight()) * track.getHeight()) - 2*vertScrollbarWidth
                                    fill: vertScrollbarThumbFill
                                    arcHeight: bind vertScrollbarWidth/2
                                    arcWidth: bind vertScrollbarWidth/2
                                    onMouseDragged: function(e:MouseEvent):Void {
                                        scrollDown.stop(); 
                                        scrollUp.stop(); 
                                        scrollTo(e.getDragY() - thumbStartY);
                                    }
                                }

                            ]

                        }
                    ]
                } 
            ]
            clip:
                Rectangle {
                    width: bind width
                    height: bind height
                }
                
            onMouseWheelMoved: function(e:MouseEvent):Void {
                scrollDown.stop(); 
                scrollUp.stop(); 
                scrollBy(e.getWheelRotation() * scrollStepSize);
            }
        };
    }
    
    public attribute scrollDown = Timeline {
        keyFrames: [
            KeyFrame { 
                time:100ms 
                values: [
                    scrollValue => scrollStepSize tween Interpolator.LINEAR,
                ]
                action: function() {
                    scrollBy(scrollStepSize);
                }
            },
        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    public attribute scrollUp = Timeline {
        keyFrames: [
            KeyFrame { 
                time:100ms 
                values: [
                    scrollValue => scrollStepSize tween Interpolator.LINEAR,
                ]
                action: function() {
                    scrollBy(0 - scrollStepSize);
                }
            },
        ]
        repeatCount: java.lang.Double.POSITIVE_INFINITY
    };

    public function scrollBy(pixels:Number) {
        var tempY = thumbEndY + pixels;
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
    
    public function scrollTo(pos:Number) {
        var tempY = pos;
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
    
    public function scrollToTop() {
        scrollTo(0);
    }
}