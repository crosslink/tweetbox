/*
 * FlowBox.fx
 *
 * Created on 9-jan-2009, 9:32:27
 */

package tweetbox.ui.layout;

import javafx.scene.layout.Container;
import javafx.scene.layout.Resizable;
import javafx.scene.Group;
import javafx.scene.Node;

/**
 * @author mnankman
 */

public var FLOWORIENTATION_HORIZONTAL:Integer = 0;
public var FLOWORIENTATION_VERTICAL:Integer = 1;

public class FlowBox extends Container {

    public var orientation:Integer = FLOWORIENTATION_HORIZONTAL;
    public var spacing:Integer = 5;

    override var content on replace {
        impl_requestLayout();
    }

    override var width on replace {
        impl_requestLayout();
    }

    override var height on replace {
        impl_requestLayout();
    }

    override var maximumHeight = bind height;

    override var maximumWidth = bind width;

    init {
        impl_layout = doFlowLayout;
    }

    function getContent(): Node[] {
        return content;
    }

    function doFlowLayout(g:Group):Void {
        if (orientation == FLOWORIENTATION_HORIZONTAL) then {
            doHorizontalFlowLayout(g);
        }
        else if (orientation == FLOWORIENTATION_VERTICAL) then {
            doVerticalFlowLayout(g);
        }
    }

    function doHorizontalFlowLayout(g:Group):Void {
        var x:Number = 0;
        var y:Number = 0;
        var rowHeight:Number = 0;
        var nodes:Node[] = getContent();
        for (node:Node in nodes) {
            if (x+node.boundsInLocal.width+spacing >= maximumWidth) {
                y += rowHeight + spacing;
                x = 0;
                rowHeight = 0;
            }

            node.impl_layoutX = x;
            node.impl_layoutY = y;

            // update the height of the current row
            if (node.boundsInLocal.height > rowHeight) rowHeight = node.boundsInLocal.height;

            x += node.boundsInLocal.width + spacing;
        }
    }

    function doVerticalFlowLayout(g:Group):Void {
        var x:Number = 0;
        var y:Number = 0;
        var columnWidth:Number = 0;
        var nodes:Node[] = getContent();
        for (node:Node in nodes) {
            if (y+node.boundsInLocal.height+spacing >= maximumHeight) {
                x += columnWidth + spacing;
                y = 0;
                columnWidth = 0;
            }
            node.impl_layoutX = x;
            node.impl_layoutY = y;

            // update the width of the current column
            if (node.boundsInLocal.width > columnWidth) columnWidth = node.boundsInLocal.width;

            y += node.boundsInLocal.height + spacing;
        }
    }
}
