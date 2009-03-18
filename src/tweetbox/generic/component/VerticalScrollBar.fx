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

import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */

public class VerticalScrollBar extends ScrollBar {

    /** The view (a Node) that is scrolled by this scrollbar */
    public var view:Node;

    var viewHeight = bind view.boundsInLocal.height on replace {
        if (view != null) scrolledViewDimension = viewHeight;
    }

    var nodeStyle = bind Style.getApplicationStyle();
    var scrollbarTrackFill:Paint = bind nodeStyle.SCROLLBAR_TRACK_FILL;
    var scrollbarThumbFill:Paint = bind nodeStyle.VERTICALSCROLLBAR_THUMB_FILL;
    var scrollbarButtonFill:Paint = bind nodeStyle.BUTTON_FILL;

    override var size = bind height;
    override var scrollButtonSize = width;

    var thumb:Rectangle;
    var track:Rectangle;
    var scrollForwardBtn:Rectangle;
    var scrollBackwardsBtn:Rectangle;

    var upArrowShape:Polyline = Polyline {
        blocksMouse:false
        fill: bind scrollbarTrackFill
        points: arrowPoints
    };

    var downArrowShape:Polyline = Polyline {
        rotate: 180
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
                        upArrowShape
                    ]
                },

                // scroll button "down"
                Group {
                    translateY: bind height - width 
                    translateX: 0
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
                        downArrowShape
                    ]

                },

                // track + thumb
                Group {
                    translateY: bind scrollForwardBtn.layoutBounds.height
                    translateX: 0
                    content: [
                        track = Rectangle {
                            x: 0
                            y: 0
                            width: bind width
                            height: bind trackLength
                            arcHeight: scrollButtonSize / 2
                            arcWidth: scrollButtonSize / 2
                            fill: bind scrollbarTrackFill

                            onMouseReleased: function(e:MouseEvent):Void {
                                scrollForward.stop();
                                scrollBackwards.stop();
                                scrollTo(e.y)
                            }
                        },
                        //Scrollbar thumb
                        thumb = Rectangle {
                            blocksMouse:true
                            x: 0
                            y: bind thumbPos
                            width: width
                            height: bind thumbLength
                            fill: bind scrollbarThumbFill
                            arcHeight: scrollButtonSize / 2
                            arcWidth: scrollButtonSize / 2

                            onMouseDragged: function(e:MouseEvent):Void {
                                //println("thumb dragged: {e} dragAnchorY={e.dragAnchorY} dragY={e.dragY}");
                                scrollForward.stop();
                                scrollBackwards.stop();
                                scrollTo(e.y)
                            }
                        }

                    ]

                }
            ]
        };
    }
}