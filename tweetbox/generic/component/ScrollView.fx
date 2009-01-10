/*
 * TweetsView.fx
 *
 * Created on 31-okt-2008, 9:33:30
 */

package tweetbox.generic.component;

import javafx.scene.input.*;
import javafx.scene.*;
import javafx.scene.shape.*;
import javafx.animation.*;
import javafx.scene.transform.*;
import javafx.scene.effect.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
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
    public var height:Number;

  /*
   * Contains the width of the view in pixels.
   */
    public var width:Number;

    var nodeStyle = Style.getApplicationStyle();

  /*
   * The color or gradient of the vertical scrollbar.
   */
    var vertScrollbarFill:Paint = nodeStyle.SCROLLBAR_TRACK_FILL;
   
  /*
   * The color or gradient of the vertical scrollbar thumb.
   */
    var vertScrollbarThumbFill:Paint = nodeStyle.SCROLLBAR_THUMB_FILL;
   
  /*
   * The width (in pixels) of the vertical scrollbar.
   */
    public var vertScrollbarWidth:Integer = 14;

    public var scrollStepSize:Integer = 5;
    
    public var content: Node[];
    
    var thumbStartY = 0.0;
    var thumbEndY = 0.0;
    var scrollValue = 0.0;
    var thumb:Rectangle;
    var track:Rectangle;
    var scrollUpBtn:Rectangle;
    var scrollDownBtn:Rectangle;
    
    public override function create(): Node {
        return Group {
            var contentContainerRef:VBox;
            var scrollBarRef:Group;
            blocksMouse:true
            content: [
                contentContainerRef = VBox {
                    transforms: bind [Translate.translate(0, -1.0 * thumbEndY * contentContainerRef.boundsInLocal.height / track.layoutBounds.height)]
                    content: bind for (node:Node in content) {node}
                },
                scrollBarRef = Group {
                    visible: bind (contentContainerRef.layoutBounds.height > height)
                    transforms: bind [Translate.translate(width - vertScrollbarWidth, 0)]
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
                                        scrollUp.play(); 
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
                                        scrollDown.play(); 
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
                            translateY: bind scrollUpBtn.layoutBounds.height
                            content: [
                                track = Rectangle {
                                    x: 0
                                    y: 0
                                    width: bind vertScrollbarWidth
                                    height: bind height - scrollDownBtn.layoutBounds.height - scrollUpBtn.layoutBounds.height 
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
                                    height: bind (track.layoutBounds.height / (contentContainerRef.boundsInLocal.height) * track.layoutBounds.height) - 2*vertScrollbarWidth
                                    fill: vertScrollbarThumbFill
                                    arcHeight: bind vertScrollbarWidth/2
                                    arcWidth: bind vertScrollbarWidth/2
                                    onMouseDragged: function(e:MouseEvent):Void {
                                        scrollDown.stop(); 
                                        scrollUp.stop(); 
                                        scrollTo(e.dragY - thumbStartY);
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
                scrollBy(e.wheelRotation * scrollStepSize);
            }
        };
    }
    
    public var scrollDown = Timeline {
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

    public var scrollUp = Timeline {
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
        if (tempY >= 0 and tempY + thumb.layoutBounds.height <= track.layoutBounds.height) {
            thumbEndY = tempY; 
        }
        else if (tempY < 0) {
            thumbEndY = 0;
        }
        else {
            thumbEndY = track.layoutBounds.height - thumb.layoutBounds.height;
        }
    }
    
    public function scrollTo(pos:Number) {
        var tempY = pos;
        // Keep the scroll thumb within the bounds of the scrollbar
        if (tempY >= 0 and tempY + thumb.layoutBounds.height <= track.layoutBounds.height) {
            thumbEndY = tempY; 
        }
        else if (tempY < 0) {
            thumbEndY = 0;
        }
        else {
            thumbEndY = track.layoutBounds.height - thumb.layoutBounds.height;
        }
    }
    
    public function scrollToTop() {
        scrollTo(0);
    }
}