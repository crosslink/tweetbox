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
import javafx.geometry.Bounds;
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
    public override function create(data:Object, bounds:Bounds) {
        def theme = data as Theme;
        return Group {
            content: [
                Rectangle {
                    height: bounds.height-2
                    width: bounds.width-2
                    fill: theme.APPLICATION_BACKGROUND_FILL
                    stroke: theme.APPLICATION_BACKGROUND_STROKE
                }

                Rectangle {
                    translateY: 2
                    translateX:2
                    width: bounds.width - 4
                    height: theme.DIALOG_TITLEBAR_TEXT_FONT.size + 4
                    fill: theme.DIALOG_TITLEBAR_FILL
                },

                Text {
                    translateY: theme.DIALOG_TITLEBAR_TEXT_FONT.size + 2
                    translateX: 10
                    content: theme.NAME
                    fill: theme.DIALOG_TITLEBAR_TEXT_FILL
                    font: theme.DIALOG_TITLEBAR_TEXT_FONT
                },

                Button {
                    width: 60
                    translateX: 3
                    translateY: 24
                    label: "button"
                    overrideNodeStyle: theme
                },

                HorizontalScrollBar {
                    translateX: 3
                    translateY: 50
                    width: 60
                    overrideNodeStyle: theme
                    scrolledViewDimension: bounds.width * 2
                    visible: true
                },

                Rectangle {
                    translateY: 24
                    translateX: 70
                    width: bounds.width - 75
                    height: 30
                    arcWidth:10
                    arcHeight:10
                    fill: bind theme.UPDATE_FILL
                },

                Text {
                    translateY: theme.UPDATE_TEXT_FONT.size + 36
                    translateX: 80
                    content: "tweet content"
                    fill: theme.UPDATE_TEXT_FILL
                    font: theme.UPDATE_TEXT_FONT
                },

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
