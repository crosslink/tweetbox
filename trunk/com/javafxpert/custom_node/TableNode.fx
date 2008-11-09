/*
*  TableNode.fx -
*  A custom node that contains rows and columns, each cell
*  containing a node.
*
*  Developed 2008 by James L. Weaver (jim.weaver at lat-inc.com)
*  to demonstrate how to create custom nodes in JavaFX
*/

package com.javafxpert.custom_node;

import javafx.input.*;
import javafx.scene.*;
import javafx.scene.geometry.*;
import javafx.scene.paint.*;
import javafx.scene.transform.*;
import java.lang.System;

/*
* A custom node that contains rows and columns, each cell
* containing a node.  Column widths may be set individually,
* and the height of the rows can be set.  In addition, several
* other attributes such as width and color of the scrollbar
* may be set.  The scrollbar will show only when necessary,
* and overlays the right side of each row, so the rightmost
* column should be given plenty of room to display data and
* a scrollbar.
*/
public class TableNode extends CustomNode {

  /*
   * Contains the height of the table in pixels.
   */
    public attribute height:Integer = 200;
   
  /*
   * Contains the height of each row in pixels.
   */
    public attribute rowHeight:Integer;
   
  /*
   * A sequence containing the column widths in pixels.  The
   * number of elements in the sequence determines the number of
   * columns in the table.
   */
    public attribute columnWidths:Integer[];
   
  /*
   * A sequence containing the nodes in the cells.  The nodes are
   * placed from left to right, continuing to the next row when
   * the current row is filled.
   */
    public attribute content:Node[];
   
  /*
   * The selected row number (zero-based)
   */
    public attribute selectedIndex:Integer;
   
  /*
   * The height (in pixels) of the space between rows of the table.
   * This space will be filled with the tableFill color.
   */
    public attribute rowSpacing:Integer = 1;
   
  /*
   * The background color of the table
   */
    public attribute tableFill:Paint;
   
  /*
   * The background color of an unselected row
   */
    public attribute rowFill:Paint;
   
  /*
   * The background color of a selected row
   */
    public attribute selectedRowFill:Paint;
   
  /*
   * The color or gradient of the vertical scrollbar.
   */
    public attribute vertScrollbarFill:Paint = Color.BLACK;
   
  /*
   * The color or gradient of the vertical scrollbar thumb.
   */
    public attribute vertScrollbarThumbFill:Paint = Color.WHITE;
   
  /*
   * The width (in pixels) of the vertical scrollbar.
   */
    public attribute vertScrollbarWidth:Integer = 20;
   
  /*
   * The number of pixels from the left of a cell to place the node
   */
    private attribute cellHorizMargin:Integer = 10;
   
  /*
   * Contains the width of the table in pixels.  This is currently a
   * calculated value based upon the specified column widths
   */
    private attribute width:Integer = bind
    computePosition(columnWidths, sizeof columnWidths);
   
    private function computePosition(sizes:Integer[], element:Integer) {
        var position = 0;
        if (
        sizeof sizes > 1) {
            for (i in [0..
                element - 1]) {
                position += sizes[i];
            }
        }
        return position;
    }
 
  /**
   * The onSelectionChange function attribute that is executed when the
   * a row is selected
   */
    public attribute onSelectionChange:function(row:Integer):Void;
   
  /**
   * Create the Node
   */
    public function create():Node {
        var numRows = sizeof content / sizeof columnWidths;
        var tableContentsNode:Group;
        var needScrollbar:Boolean = bind (rowHeight + rowSpacing) * numRows  > height;
        Group {
            var thumbStartY = 0.0;
            var thumbEndY = 0.0;
            var thumb:Rectangle;
            var track:Rectangle;
            var rowRef:Group;
            content: [
                for (row in [0..numRows - 1], colWidth in columnWidths) {
                    Group {
                        transform: bind
                        Translate.translate(computePosition(columnWidths, indexof colWidth) +
                                  cellHorizMargin,
                                  ((rowHeight + rowSpacing) * row) + ( - 1.0 * thumbEndY *
                        ((rowHeight + rowSpacing) * numRows) / height))
                        content: bind [
                            Rectangle {
                                width: colWidth
                                height: rowHeight
                                fill: if (indexof row == selectedIndex)
                                    selectedRowFill
                                else
                                    rowFill
                            },
                            Line {
                                startX: 0
                                startY: 0
                                endX: colWidth
                                endY: 0
                                strokeWidth: rowSpacing
                                stroke: tableFill
                            },
                            rowRef = Group {
                                var node = content[
                                    indexof row * (sizeof columnWidths) + indexof colWidth
                                ];
                                transform: bind Translate.translate(0, rowHeight / 2 - node.getHeight() / 2)
                                content: node
                            }
                        ]
                        onMouseClicked:
                            function (me:MouseEvent) {
                                selectedIndex = row;
                                onSelectionChange(row);
                            }
                    }
                },
        // Scrollbar
        if (needScrollbar)
                Group {
                    transform: bind Translate.translate(width - vertScrollbarWidth, 0)
                    content: [
                        track = Rectangle {
                            x: 0
                            y: 0
                            width: vertScrollbarWidth
                            height: bind height
                            fill: vertScrollbarFill
                        },
              //Scrollbar thumb
                        thumb = Rectangle {
                            x: 0
                            y: bind thumbEndY
                            width: vertScrollbarWidth
                            height: bind 1.0 * height / ((rowHeight + rowSpacing) * numRows) * height
                            fill: vertScrollbarThumbFill
                            arcHeight: 10
                            arcWidth: 10
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
                var tempY = thumbEndY + e.getWheelRotation() * 4;
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
    }
}  