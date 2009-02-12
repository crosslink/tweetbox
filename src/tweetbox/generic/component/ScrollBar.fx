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

public abstract class ScrollBar extends CustomNode {

    /** the scroll stepsize */
    public var scrollStepSize:Integer = 5;

    /** The width (in pixels) of the scrollbar */
    public var width:Number = 14;

    /** The height (in pixels) of the scrollbar */
    public var height:Number = 14;

    /**
     * Scroll the associated view by the provided number of pixels
     * @param pixels - the number of pixels to scroll
     */
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

    /**
     * Scroll the associated view to the provided position
     * @param pos - the position to scroll to
     */
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

    /**
     * The size, i.e. the total length, of the entire scroll bar;
     * DERIVED CLASSES SHOULD OVERRIDE THIS
     */
    protected var size:Number;

    /**
     * The dimension, i.e. height or width, of the scrolled view;
     * DERIVED CLASSES SHOULD OVERRIDE THIS
     */
    protected var scrolledViewDimension:Number;

    /**
     * The size (i.e. the length of either side because these buttons are always square) of the scroll buttons;
     * DERIVED CLASSES SHOULD OVERRIDE THIS
     */
    protected var scrollButtonSize:Number;

    /** 
     * the ratio between the scrolled dimension of the view and the length of the track;
     * DERIVED CLASSES SHOULD *NOT* OVERRIDE THIS
     */
    protected var viewTrackRatio:Number = bind scrolledViewDimension / trackLength;
    
    /** 
     * the ratio between the length of the scroll track and the scrolled dimension of the view;
     * DERIVED CLASSES SHOULD *NOT* OVERRIDE THIS
     */
    protected var trackViewRatio:Number = bind trackLength / scrolledViewDimension;

    protected var scrollBarButtonSizeCorrection:Number = 2 * scrollButtonSize;

    /**
     * calculated length of the scroll track;
     * DERIVED CLASSES SHOULD *NOT* OVERRIDE THIS
     */
    protected var trackLength:Number = bind size - scrollBarButtonSizeCorrection;

    /** length of the scrollbar thumb; 
     * DERIVED CLASSES SHOULD *NOT* OVERRIDE THIS
     */
    protected var thumbLength:Number = bind trackViewRatio * trackLength - scrollBarButtonSizeCorrection;

    /** the position ot the scroll thumb on the scroll track. 
     * DERIVED CLASSES SHOULD *NOT* OVERRIDE THIS
     */
    protected var thumbPos = 0.0;

    /**
     * The current scroll position of the view
     * The ScrollView component uses this to transform the view such that the correct portion is shown
     * DERIVED CLASSES SHOULD *NOT* OVERRIDE THIS
     */
    public-read var scrollPosition:Number = bind 0.0 - (thumbPos * viewTrackRatio);

    /** the points of the arrow shapes defined by the deriving classes */
    protected var arrowPoints:Number[] = [
        1.0 * scrollButtonSize / 2, 1.0 * scrollButtonSize / 4,
        1.0 * scrollButtonSize / 4, 3.0 * scrollButtonSize / 4,
        3.0 * scrollButtonSize / 4, 3.0 * scrollButtonSize / 4
    ];

    /** used by the scroll timelines */
    protected var scrollValue = 0.0;

    /** timeline for smoothly scrolling forwards one step */
    protected var scrollForward = Timeline {
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

    /** timeline for smoothly scrolling backwards one step */
    protected var scrollBackwards = Timeline {
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


}