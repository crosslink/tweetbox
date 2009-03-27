/*
 * ListBox.fx
 *
 * Created on 3-mrt-2009, 11:27:22
 */

package tweetbox.generic.component;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.layout.VBox;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.geometry.Rectangle2D;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.animation.Interpolator;

import java.lang.Math;

import tweetbox.generic.component.listboxcellrenderer.*;

/**
 * @author mnankman
 */

public class ListBox extends CustomNode {

    public var cellHeight:Number = 20;
    public var cellSpacing:Number = 5;

    public var cellRenderer:ListBoxCellRenderer;

    public var model: Object[] on replace {
        totalHeight = sizeof model * (cellHeight+cellSpacing);
        scroll(vertScrollBar.scrollPosition);
    };

    public var height:Number on replace {
        visibleCells = Math.round(height / (cellHeight+cellSpacing));
    }

    public var width:Number;

    var scrollStepSize:Number = bind cellHeight+cellSpacing;

    var cellBounds = Rectangle2D {
        width: width
        height: cellHeight
    }

    var visibleCells:Integer = 0;

    var cells:Node[];

    var totalHeight:Number = 0;

    var vertScrollBar:ScrollBar;

    var showVerticalScrollBar:Boolean = bind (totalHeight > height) on replace {
        if (not showVerticalScrollBar) {
            vertScrollBar.scrollTo(0);
        }
    };

    var lastStartIndex:Integer = 0;

    public-read var selectedNode:Node = null;

    var startIndex:Integer;

    var scroller = Timeline {
        keyFrames: [
            KeyFrame {
                time: bind 25ms
                action: renderCells
            }
        ]
    };

    function scroll(scrollPosition:Number) {
        scroller.stop();
        startIndex = Math.round((0.0-scrollPosition) / (cellHeight+cellSpacing));
        scroller.play();
    }


    function renderCells():Void {
        println("renderCells() {startIndex}");
        var nodes:Node[] = [];
        var n:Node;
        var cellWrapper:Group;
        var nextY:Number = 0.0;
        var nodeIndex:Integer;
        var endIndex:Integer;

        for (i:Integer in [0..visibleCells]) {
            nodeIndex = startIndex+i;
            if (nodeIndex < sizeof model) {
                n = cellRenderer.create(model[nodeIndex], cellBounds);
                cellWrapper = Group {
                    translateY:nextY
                    content: [
                        n,
                        Rectangle {
                            width: cellBounds.width
                            height: cellBounds.height
                            fill: Color.TRANSPARENT
                            onMouseReleased: function(e:MouseEvent) {
                                selectedNode = n;
                            }
                        }
                    ]
                }
                nextY = nextY + cellHeight + cellSpacing;
                insert cellWrapper into nodes;
                endIndex = nodeIndex;
            }
        }
        lastStartIndex = startIndex;
        cells = nodes;
    }

    public override function create(): Node {
        scroll(0);
        return Group {
            content: [
                Group{
                    content:bind cells
                },
                vertScrollBar = VerticalScrollBar {
                    height: bind height
                    visible: bind showVerticalScrollBar
                    translateX: bind width
                    scrolledViewDimension: bind totalHeight
                    scrollStepSize: cellHeight+cellSpacing
                    onScroll: function(p:Number) {
                        scroll(p);
                    }
                }
            ]
            
            clip:
                Rectangle {
                    width: bind if (vertScrollBar.visible) width + vertScrollBar.layoutBounds.width else width
                    height: bind height
                }

            onMouseWheelMoved: function(e:MouseEvent):Void {
                vertScrollBar.scrollForward.stop();
                vertScrollBar.scrollBackwards.stop();
                vertScrollBar.scrollBy(e.wheelRotation * scrollStepSize);
            }
        }
    }
}


/* -- TEST CODE --*/

import javafx.stage.Stage;
import javafx.scene.Scene;

function run(): Void {
    Stage {
        width: 400
        height: 400
        scene: Scene {
            fill: Color.WHITE
            content: [
                ListBox {
                    translateX: 20
                    translateY: 20
                    width: 100
                    height: 200
                    model: bind for (i:Integer in [0..20]) {"this is line {i}"}
                    cellRenderer: SimpleCellRenderer{}
                    cellHeight:50
                }
            ]
        }
    }
}