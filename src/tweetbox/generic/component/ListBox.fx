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
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.geometry.BoundingBox;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;

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
        delete cells; // force complete re-rendering of the list
        //scroll(vertScrollBar.scrollPosition);
        scroll(0.0);
    };

    public var width:Number;

    public var height:Number on replace {
        visibleCells = Math.round(height / (cellHeight+cellSpacing)) + 1;
    }

    public var scrollStepSize:Number = cellHeight+cellSpacing;

    var previousVisibleCells:Integer = 0;
    var visibleCells:Integer = 0 on replace {
        if (previousVisibleCells != visibleCells) renderCells();
        previousVisibleCells = visibleCells;
    };

    var cells:Node[];

    var totalHeight:Number = bind sizeof model * (cellHeight+cellSpacing);

    var vertScrollBar:ScrollBar;

    var showVerticalScrollBar:Boolean = bind (totalHeight > height) on replace {
        if (not showVerticalScrollBar) {
            vertScrollBar.scrollTo(0);
        }
    };

    var lastStartIndex:Integer = 0;

    public-read var selectedNode:Node = null;

    var startIndex:Integer;
    var smoothScrollOffset:Number = 0;

    var scroller = Timeline {
        keyFrames: [
            KeyFrame {
                time: bind 15ms
                action: renderCells
            }
        ]
    };

    function scroll(scrollPosition:Number) {
        scroller.stop();
        def p:Number = (0.0-scrollPosition) / (cellHeight+cellSpacing);
        startIndex = Math.max(0, Math.round(p)-1);
        //smoothScrollOffset = (startIndex - p) * (cellHeight+cellSpacing);
        //println("{scrollPosition} : {startIndex} - {p} = {startIndex - p}");
        scroller.play();
    }


    function renderCells():Void {
        //println("renderCells() {startIndex} {lastStartIndex}");
        var nodes:Node[] = [];
        var n:Node;
        var cellWrapper:Group;
        var nextY:Number = 0.0;
        var nodeIndex:Integer;
        var endIndex:Integer;

        def cellBounds = BoundingBox {width: width height: cellHeight}
        
        def indexDiff:Integer = startIndex - lastStartIndex;
        def newCellsStartIndex = if (indexDiff>0) visibleCells - indexDiff else 0;
        def newCellsEndIndex = if (sizeof cells > 0) newCellsStartIndex + Math.abs(indexDiff) else visibleCells;

        for (i:Integer in [0..visibleCells]) {
            nodeIndex = startIndex+i;
            if (nodeIndex < sizeof model) {
                if (newCellsStartIndex<newCellsEndIndex and i >= newCellsStartIndex and i <= newCellsEndIndex) {
                    //println("render new cell[{i}, {nodeIndex}]");
                    //render new cells
                    n = cellRenderer.create(model[nodeIndex], cellBounds);
                    cellWrapper = Group {
                        translateY:nextY+smoothScrollOffset
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
                    insert cellWrapper into nodes;
                }
                else {
                    //println("reuse cell[{i}, {i+indexDiff}]");
                    //reuse already visible cells
                    n = cells[i+indexDiff];
                    n.translateY = nextY+smoothScrollOffset;
                    insert n into nodes;
                }
                
                nextY = nextY + cellHeight + cellSpacing;
                endIndex = nodeIndex;
            }
        }
        lastStartIndex = startIndex;
        cells = nodes;
    }

    public override function create(): Node {
        //scroll(0);
        return Group {
            content: [
                Group {
                    //translateY: bind smoothScrollOffset
                    content:bind cells
                },
                vertScrollBar = VerticalScrollBar {
                    height: bind height
                    visible: bind showVerticalScrollBar
                    translateX: bind width
                    scrolledViewDimension: bind totalHeight
                    scrollStepSize: bind scrollStepSize
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
    var model:String[] = for (i:Integer in [0..20]) {"this is line {i}"};
    var n:Integer = sizeof model;
    Stage {
        width: 400
        height: 400
        scene: Scene {
            fill: Color.WHITE
            content: [
                Button {
                    label: "add item"
                    action: function() {
                        insert "this is line {++n}" into model
                    }

                }

                ListBox {
                    translateX: 20
                    translateY: 40
                    width: 100
                    height: 200
                    model: bind model
                    //scrollStepSize: 12
                    cellHeight:50
                    cellRenderer: SimpleCellRenderer{}
                }
            ]
        }
    }
}