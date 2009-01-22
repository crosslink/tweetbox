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
import java.lang.Math;

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

    var vertScrollbarFill:Paint = nodeStyle.SCROLLBAR_TRACK_FILL;
    var vertScrollbarThumbFill:Paint = nodeStyle.SCROLLBAR_THUMB_FILL;

    var scrollButtonWidth:Number = if (orientation == ORIENTATION_VERTICAL) width else height;
    var scrollButtonHeight:Number = scrollButtonWidth;
    var totalWidthOfScrollButtons:Number = 2 * scrollButtonWidth;

    /** the position ot the scroll thumb on the scroll track */
    var thumbPos = 0.0;

    var scrollValue = 0.0;
    var thumb:Rectangle;
    var track:Rectangle;
    var scrollForwardBtn:Rectangle;
    var scrollBackwardsBtn:Rectangle;

    var trackLength:Number = bind
        if (orientation == ORIENTATION_VERTICAL)
            height - totalWidthOfScrollButtons
        else
            width - totalWidthOfScrollButtons;

    var viewTrackRatio:Number = bind
        if (orientation == ORIENTATION_VERTICAL)
            view.boundsInLocal.height / trackLength
        else
            view.boundsInLocal.width / trackLength;

    var trackViewRation:Number = bind
        if (orientation == ORIENTATION_VERTICAL)
            trackLength / view.layoutBounds.height
        else
            trackLength / view.layoutBounds.width;


    var thumbLength:Number = bind trackViewRation * trackLength - totalWidthOfScrollButtons;

    public-read var scrollPosition:Number = bind 0.0 - (thumbPos * viewTrackRatio);

    var arrowPoints:Number[] = [
        1.0 * scrollButtonWidth / 2, 1.0 * scrollButtonWidth / 4,
        1.0 * scrollButtonWidth / 4, 3.0 * scrollButtonWidth / 4,
        3.0 * scrollButtonWidth / 4, 3.0 * scrollButtonWidth / 4
    ];

    var upArrowShape:Polyline = Polyline {
        blocksMouse:false
        fill: bind vertScrollbarFill
        points: arrowPoints
    };

    var downArrowShape:Polyline = Polyline {
        rotate: 180
        blocksMouse:false
        fill: bind vertScrollbarFill
        points: arrowPoints
    }

    var leftArrowShape:Polyline = Polyline {
        rotate: -90
        blocksMouse:false
        fill: bind vertScrollbarFill
        points: arrowPoints
    }

    var rightArrowShape:Polyline = Polyline {
        rotate: 90
        blocksMouse:false
        fill: bind vertScrollbarFill
        points: arrowPoints
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
                            width: scrollButtonWidth
                            height: scrollButtonHeight
                            arcHeight: scrollButtonWidth / 2
                            arcWidth: scrollButtonWidth / 2
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
                            width: scrollButtonWidth
                            height: scrollButtonHeight
                            arcHeight: scrollButtonWidth / 2
                            arcWidth: scrollButtonWidth / 2
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
                            width: bind if (orientation == ORIENTATION_HORIZONTAL) trackLength else width
                            height: bind if (orientation == ORIENTATION_VERTICAL) trackLength else height
                            arcHeight: scrollButtonWidth / 2
                            arcWidth: scrollButtonWidth / 2
                            fill: bind vertScrollbarFill

                            onMouseReleased: function(e:MouseEvent):Void {
                                scrollForward.stop();
                                scrollBackwards.stop();
                                if (orientation == ORIENTATION_VERTICAL)
                                    scrollTo(e.y)
                                else
                                    scrollTo(e.x);
                            }
                        },
                        //Scrollbar thumb
                        thumb = Rectangle {
                            blocksMouse:true
                            x: bind if (orientation == ORIENTATION_HORIZONTAL) thumbPos else 0
                            y: bind if (orientation == ORIENTATION_VERTICAL) thumbPos else 0
                            width: bind if (orientation == ORIENTATION_HORIZONTAL) thumbLength else width
                            height: bind if (orientation == ORIENTATION_VERTICAL) thumbLength else height
                            fill: vertScrollbarThumbFill
                            arcHeight: scrollButtonWidth / 2
                            arcWidth: scrollButtonWidth / 2

                            onMouseDragged: function(e:MouseEvent):Void {
                                //println("thumb dragged: {e} dragAnchorY={e.dragAnchorY} dragY={e.dragY}");
                                scrollForward.stop();
                                scrollBackwards.stop();
                                if (orientation == ORIENTATION_VERTICAL)
                                    scrollTo(e.y)
                                else
                                    scrollTo(e.x);
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
        var newPos = thumbPos + pixels;
        // Keep the scroll thumb within the bounds of the scrollbar
        if (newPos >= 0 and newPos + thumbLength <= trackLength) {
            thumbPos = newPos;
        }
        else if (newPos < 0) {
            // keep thumb below the top of the track
            thumbPos = 0;
        }
        else {
            // keep thumb above the bottom of the track
            thumbPos = Math.max(trackLength - thumbLength, 0.0);
        }
    }

    public function scrollTo(pos:Number) {
        // Keep the scroll thumb within the bounds of the scrollbar
        if (pos >= 0 and pos + thumbLength <= trackLength) {
            thumbPos = pos;
        }
        else if (pos < 0) {
            thumbPos = 0;
        }
        else {
            thumbPos = Math.max(trackLength - thumbLength, 0.0);
        }
    }


}