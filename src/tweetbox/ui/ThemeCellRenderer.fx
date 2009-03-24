/*
 * SimpleCellRenderer.fx
 *
 * Created on 3-mrt-2009, 12:54:24
 */

package tweetbox.ui;

import javafx.scene.Node;
import javafx.scene.text.Text;
import javafx.scene.Group;
import javafx.scene.shape.Rectangle;
import javafx.geometry.Rectangle2D;
import javafx.scene.paint.Color;
import javafx.scene.input.MouseEvent;

import tweetbox.generic.component.listboxcellrenderer.ListBoxCellRenderer;
import tweetbox.generic.component.Button;
import tweetbox.generic.component.HorizontalScrollBar;
import tweetbox.ui.style.Theme;
import tweetbox.model.Model;

/**
 * @author mnankman
 */

public class ThemeCellRenderer extends ListBoxCellRenderer {
    public override function create(data:Object, bounds:Rectangle2D) {
        def theme = data as Theme;
        return Group {
            content: [
                Rectangle {
                    height: bounds.height-2
                    width: bounds.width-2
                    fill: theme.APPLICATION_BACKGROUND_FILL
                    stroke: theme.APPLICATION_BACKGROUND_STROKE
                }

                Button {
                    width: bounds.width-10
                    translateX: 5
                    translateY: 5
                    label: "button"
                    overrideNodeStyle: theme
                }

                HorizontalScrollBar {
                    translateX: 5
                    translateY: 30
                    width: bounds.width - 10
                    overrideNodeStyle: theme
                    scrolledViewDimension: bounds.width * 2
                    visible: true
                }

                Rectangle {
                    height: bounds.height
                    width: bounds.width
                    fill: Color.TRANSPARENT
                    blocksMouse:true
                    onMouseClicked: function(e:MouseEvent) {
                        Model.getInstance().config.themeName = theme.NAME;
                    }
                }

            ]

        }
    }
}
