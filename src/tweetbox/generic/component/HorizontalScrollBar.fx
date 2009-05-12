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

import tweetbox.ui.style.*;

/**
 * @author mnankman
 */

public class HorizontalScrollBar extends ScrollBar {

    /** The view (a Node) that is scrolled by this scrollbar */
    public var view:Node;

    var viewWidth = bind view.boundsInLocal.width on replace {
        if (view != null) scrolledViewDimension = viewWidth;
    }

    public var overrideNodeStyle:Theme = null on replace {
        if (overrideNodeStyle != null) nodeStyle = overrideNodeStyle;
    }
    var nodeStyle = bind Style.getApplicationStyle();
    var scrollbarTrackFill:Paint = bind nodeStyle.SCROLLBAR_TRACK_FILL;
    var scrollbarThumbFill:Paint = bind nodeStyle.HORIZONTALSCROLLBAR_THUMB_FILL;
    var scrollbarButtonFill:Paint = bind nodeStyle.BUTTON_FILL;

    override var size = bind width;
    override var scrollButtonSize = height;
    
    var thumb:Rectangle;
    var track:Rectangle;
    var scrollForwardBtn:Rectangle;
    var scrollBackwardsBtn:Rectangle;

    var leftArrowShape:Polyline = Polyline {
        rotate: -90
        blocksMouse:false
        fill: bind scrollbarTrackFill
        points: arrowPoints
    }

    var rightArrowShape:Polyline = Polyline {
        rotate: 90
        blocksMouse:false
        fill: bind scrollbarTrackFill
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
                            width: scrollButtonSize
                            height: scrollButtonSize
                            arcHeight: scrollButtonSize / 2
                            arcWidth: scrollButtonSize / 2
                            fill: bind scrollbarButtonFill

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
                        leftArrowShape
                    ]
                },

                // scroll button "down"
                Group {
                    translateY: 0
                    translateX: bind width - height
                    content: [
                        scrollForwardBtn = Rectangle {
                            blocksMouse:true
                            x: 0
                            y: 0
                            width: scrollButtonSize
                            height: scrollButtonSize
                            arcHeight: scrollButtonSize / 2
                            arcWidth: scrollButtonSize / 2
                            fill: bind scrollbarButtonFill

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
                        rightArrowShape
                    ]

                },

                // track + thumb
                Group {
                    translateY: 0;
                    translateX: bind scrollForwardBtn.layoutBounds.width
                    content: [
                        track = Rectangle {
                            x: 0
                            y: 0
                            width: bind trackLength 
                            height: bind height
                            arcHeight: scrollButtonSize / 2
                            arcWidth: scrollButtonSize / 2
                            fill: bind scrollbarTrackFill

                            onMouseReleased: function(e:MouseEvent):Void {
                                if (updateThumbPos(e.x)!=0) {
                                    scrollForward.stop();
                                    scrollBackwards.stop();
                                    scrollTo(e.x)
                                };
                            }
                        },
                        //Scrollbar thumb
                        thumb = Rectangle {
                            blocksMouse:true
                            x: bind thumbPos
                            y: 0
                            width: bind thumbLength
                            height: height
                            fill: bind scrollbarThumbFill
                            arcHeight: scrollButtonSize / 2
                            arcWidth: scrollButtonSize / 2

                            onMouseDragged: function(e:MouseEvent):Void {
                                if (updateThumbPos(e.dragX)!=0) {
                                    scrollForward.stop();
                                    scrollBackwards.stop();
                                    scrollTo(e.x)
                                }
                            }
                        }

                    ]

                }
            ]
        };
    }
}