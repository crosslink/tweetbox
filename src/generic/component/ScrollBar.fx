/*
 * ScrollBar.fx
 *
 * Created on 12-jan-2009, 12:51:41
 */

package tweetbox.generic.component;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Polyline;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Paint;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.animation.Interpolator;
//import javafx.scene.layout.Container;

import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */

public-read var ORIENTATION_VERTICAL:Integer = 0;
public-read var ORIENTATION_HORIZONTAL:Integer = 1;

public class ScrollBar extends CustomNode {

    public var view:Node;
    public var width:Number = 14;
    public var height:Number = 14;
    public var scrollStepSize:Integer = 5;
    public var orientation:Integer = ORIENTATION_VERTICAL;

    var nodeStyle = Style.getApplicationStyle();

  /*
   * The color or gradient of the vertical scrollbar.
   */
    var vertScrollbarFill:Paint = nodeStyle.SCROLLBAR_TRACK_FILL;

  /*
   * The color or gradient of the vertical scrollbar thumb.
   */
    var vertScrollbarThumbFill:Paint = nodeStyle.SCROLLBAR_THUMB_FILL;

    var scrollButtonWidth:Number = bind if (orientation == ORIENTATION_VERTICAL) width else height;
    var scrollButtonHeight:Number = bind scrollButtonWidth;

    var thumbStartPos = 0.0;
    var thumbEndPos = 0.0;
    var scrollValue = 0.0;
    var thumb:Rectangle;
    var track:Rectangle;
    var scrollForwardBtn:Rectangle;
    var scrollBackwardsBtn:Rectangle;

    var arrowPoints:Number[] = bind [
        1.0 * scrollButtonWidth / 2, 1.0 * scrollButtonWidth / 4,
        1.0 * scrollButtonWidth / 4, 3.0 * scrollButtonWidth / 4,
        3.0 * scrollButtonWidth / 4, 3.0 * scrollButtonWidth / 4
    ];

    var upArrowShape:Polyline = Polyline {
        blocksMouse:false
        fill: bind vertScrollbarFill
        points: bind arrowPoints
    };

    var downArrowShape:Polyline = Polyline {
        rotate: 180
        blocksMouse:false
        fill: bind vertScrollbarFill
        points: bind arrowPoints
    }

    var leftArrowShape:Polyline = Polyline {
        rotate: -90
        blocksMouse:false
        fill: bind vertScrollbarFill
        points: bind arrowPoints
    }

    var rightArrowShape:Polyline = Polyline {
        rotate: 90
        blocksMouse:false
        fill: bind vertScrollbarFill
        points: bind arrowPoints
    }

    public override function create(): Node {
        return Group {
            content: [
                // scroll button "up"
                Group {
                    content: [
                        scrollForwardBtn = Rectangle {
                            blocksMouse:true
                            x: 0
                            y: 0
                            width: bind scrollButtonWidth
                            height: bind scrollButtonHeight
                            arcHeight: bind scrollButtonWidth / 2
                            arcWidth: bind scrollButtonWidth / 2
                            fill: bind vertScrollbarThumbFill

                            onMousePressed: function(e:MouseEvent):Void {
                                scrollForward.stop();
                                scrollBackwards.play();
                            }
                            onMouseReleased: function(e:MouseEvent):Void {
                                scrollForward.stop();
                                scrollBackwards.stop();
                            }
                            onMouseClicked: function(e:MouseEvent):Void {
                                scrollForward.stop();
                                scrollBackwards.stop();
                                scrollBy(0 - scrollStepSize);
                            }
                        },
                        if (orientation == ORIENTATION_VERTICAL) upArrowShape else leftArrowShape
                    ]
                },

                // scroll button "down"
                Group {
                    translateY: bind if (orientation == ORIENTATION_VERTICAL) height - width else 0
                    translateX: bind if (orientation == ORIENTATION_HORIZONTAL) width - height else 0
                    content: [
                        scrollForwardBtn = Rectangle {
                            blocksMouse:true
                            x: 0
                            y: 0
                            width: bind scrollButtonWidth
                            height: bind scrollButtonHeight
                            arcHeight: bind scrollButtonWidth / 2
                            arcWidth: bind scrollButtonWidth / 2
                            fill: bind vertScrollbarThumbFill

                            onMousePressed: function(e:MouseEvent):Void {
                                scrollBackwards.stop();
                                scrollForward.play();
                            }
                            onMouseReleased: function(e:MouseEvent):Void {
                                scrollBackwards.stop();
                                scrollForward.stop();
                            }
                            onMouseClicked: function(e:MouseEvent):Void {
                                scrollForward.stop();
                                scrollBackwards.stop();
                                scrollBy(scrollStepSize);
                            }
                        },
                        if (orientation == ORIENTATION_VERTICAL) downArrowShape else rightArrowShape
                    ]

                },

                // track + thumb
                Group {
                    translateY: bind if (orientation == ORIENTATION_VERTICAL) scrollForwardBtn.layoutBounds.height else 0;
                    translateX: bind if (orientation == ORIENTATION_HORIZONTAL) scrollForwardBtn.layoutBounds.width else 0;
                    content: [
                        track = Rectangle {
                            x: 0
                            y: 0
                            width: bind if (orientation == ORIENTATION_HORIZONTAL) width - 2 * scrollButtonWidth else width
                            height: bind if (orientation == ORIENTATION_VERTICAL) height - 2 * scrollButtonHeight else height
                            arcHeight: bind scrollButtonWidth / 2
                            arcWidth: bind scrollButtonWidth / 2
                            fill: bind vertScrollbarFill
                        },
                        //Scrollbar thumb
                        thumb = Rectangle {
                            blocksMouse:true
                            x: bind if (orientation == ORIENTATION_HORIZONTAL) thumbEndPos else 0
                            y: bind if (orientation == ORIENTATION_VERTICAL) thumbEndPos else 0
                            
                            width: bind
                                if (orientation == ORIENTATION_HORIZONTAL)
                                    (track.layoutBounds.width / (view.layoutBounds.width) * track.layoutBounds.width) - 2 * scrollButtonWidth
                                else
                                    width
                            
                            height: bind
                                if (orientation == ORIENTATION_VERTICAL)
                                    (track.layoutBounds.height / (view.layoutBounds.height) * track.layoutBounds.height) - 2 * scrollButtonHeight
                                else
                                    height

                            fill: vertScrollbarThumbFill
                            arcHeight: bind scrollButtonWidth / 2
                            arcWidth: bind scrollButtonWidth / 2
                            onMouseDragged: function(e:MouseEvent):Void {
                                scrollForward.stop();
                                scrollBackwards.stop();
                                if (orientation == ORIENTATION_VERTICAL)
                                    scrollTo(e.dragY - thumbStartPos)
                                else
                                    scrollTo(e.dragX - thumbStartPos);
                            }
                        }

                    ]

                }
            ]
        };
    }

    public var scrollForward = Timeline {
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

    public var scrollBackwards = Timeline {
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
        var tempPos = thumbEndPos + pixels;
        var thumbLength = if (orientation == ORIENTATION_VERTICAL) thumb.layoutBounds.height else thumb.layoutBounds.width;
        var trackLength = if (orientation == ORIENTATION_VERTICAL) track.layoutBounds.height else track.layoutBounds.width;
        // Keep the scroll thumb within the bounds of the scrollbar
        if (tempPos >= 0 and tempPos + thumbLength <= trackLength) {
            thumbEndPos = tempPos;
        }
        else if (tempPos < 0) {
            thumbEndPos = 0;
        }
        else {
            thumbEndPos = trackLength - thumbLength;
        }
    }

    public function scrollTo(pos:Number) {
        var tempPos = pos;
        var thumbLength = if (orientation == ORIENTATION_VERTICAL) thumb.layoutBounds.height else thumb.layoutBounds.width;
        var trackLength = if (orientation == ORIENTATION_VERTICAL) track.layoutBounds.height else track.layoutBounds.width;
        // Keep the scroll thumb within the bounds of the scrollbar
        if (tempPos >= 0 and tempPos + thumbLength <= trackLength) {
            thumbEndPos = tempPos;
        }
        else if (tempPos < 0) {
            thumbEndPos = 0;
        }
        else {
            thumbEndPos = trackLength - thumbLength;
        }
    }

    public-read var scrollPosition:Number = bind
        if (orientation == ORIENTATION_VERTICAL)
            -1.0 * thumbEndPos * view.boundsInLocal.height / track.layoutBounds.height
        else
            -1.0 * thumbEndPos * view.boundsInLocal.width / track.layoutBounds.width

}