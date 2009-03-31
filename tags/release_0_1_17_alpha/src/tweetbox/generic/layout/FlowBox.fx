/*
 * FlowBox.fx
 *
 * Created on 9-jan-2009, 9:32:27
 */

package tweetbox.generic.layout;

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
    var c = 0;

    public var orientation:Integer = FLOWORIENTATION_HORIZONTAL;
    public var spacing:Integer = 5;

    public var invalidLayout:Boolean = false on replace {
        if (invalidLayout) impl_requestLayout();
    }

    override var content;

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
        println("FlowBox.doFlowLayout({c}) FlowBox.invalidLayout = {invalidLayout}"); c++;
        if (orientation == FLOWORIENTATION_HORIZONTAL) then {
            doHorizontalFlowLayout(g);
        }
        else if (orientation == FLOWORIENTATION_VERTICAL) then {
            doVerticalFlowLayout(g);
        }
        invalidLayout = false;
    }

    function doHorizontalFlowLayout(g:Group):Void {
        var x:Number = 0;
        var y:Number = 0;
        var rowHeight:Number = 0;
        var w:Number = 0;
        var h:Number = 0;
        var bounds;
        for (node:Node in getContent()) {
            bounds = node.layoutBounds;
            w = bounds.width;
            h = bounds.height;
            if (x+h+spacing >= maximumWidth) {
                y += rowHeight + spacing;
                x = 0;
                rowHeight = 0;
            }

            node.impl_layoutX = x;
            node.impl_layoutY = y;

            // update the height of the current row
            if (h > rowHeight) rowHeight = h;

            x += w + spacing;
        }
    }

    function doVerticalFlowLayout(g:Group):Void {
        var x:Number = 0;
        var y:Number = 0;
        var columnWidth:Number = 0;
        var w:Number = 0;
        var h:Number = 0;
        var bounds;
        for (node:Node in getContent()) {
            bounds = node.layoutBounds;
            w = bounds.width;
            h = bounds.height;
            if (y+h+spacing >= maximumHeight) {
                x += columnWidth + spacing;
                y = 0;
                columnWidth = 0;
            }
            node.impl_layoutX = x;
            node.impl_layoutY = y;

            // update the width of the current column
            if (w > columnWidth) columnWidth = w;

            y += h + spacing;
        }
    }
}
