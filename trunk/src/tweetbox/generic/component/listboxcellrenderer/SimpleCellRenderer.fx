/*
 * SimpleCellRenderer.fx
 *
 * Created on 3-mrt-2009, 12:54:24
 */

package tweetbox.generic.component.listboxcellrenderer;

import javafx.scene.Node;
import javafx.scene.text.Text;
import javafx.scene.Group;
import javafx.scene.shape.Rectangle;
import javafx.geometry.Rectangle2D;
import javafx.scene.paint.Color;

/**
 * @author mnankman
 */

public class SimpleCellRenderer extends ListBoxCellRenderer {
    public override function create(data:Object, bounds:Rectangle2D) {
        //println("SimpleCellRenderer.create({data}, {bounds})");
        return Group {
            content: [
                
                Rectangle {
                    translateX: 0
                    translateY: 0
                    fill: Color.LIGHTGREY
                    width: bounds.width
                    height: bounds.height
                },
                Text {
                    translateY: 15
                    translateX: 0
                    content: "{data}"
                    wrappingWidth: bounds.width
                },
            ]
        }
    }
}
