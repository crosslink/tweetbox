/*
 * TabNavigator.fx
 *
 * Created on 6-feb-2009, 11:44:11
 */

package tweetbox.generic.component;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.layout.Flow;
import javafx.scene.layout.VBox;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;
import javafx.scene.text.Font;
import javafx.scene.paint.Color;

import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */

public class TabNavigator extends CustomNode {

    public var tabs:Tab[];
    public var width:Number;
    public var height:Number;

    var nodeStyle = bind Style.getApplicationStyle();

    var selectedTab:Tab = if (tabs != null and sizeof tabs > 0) tabs[0] else null;

    var currentNode:Node = bind selectedTab.node;

    var view = Group {
        translateY: -1
        content: bind [
            Rectangle {
                translateX:0
                translateY:0
                stroke: bind nodeStyle.TABVIEW_STROKE
                fill: Color.TRANSPARENT
                x:0
                y:0
                width: bind width - 2
                height: bind height - 2

            },
            selectedTab.node
        ]

    }

    public override function create(): Node {
        for (t:Tab in tabs) {
            t.onTabClicked = function(tab:Tab) {
                if (tab != selectedTab) {
                    selectedTab.selected = false;
                    selectedTab = tab;
                    selectedTab.selected = true;
                }
            }
        }
        if (selectedTab != null) {
            selectedTab.selected = true;
        }
        return VBox {
            spacing: 0
            content: [
                Flow {
                    width: bind width
                    content: tabs
                },
                view
            ]

        };
    }

}

public function run() {
    Stage {
        x:100 y:300 width:500 height:400
        onClose: function() {
            java.lang.System.exit(0);
        }
        scene:Scene {
            content: [
                TabNavigator {
                    translateX:10
                    translateY:10
                    width: 450
                    height: 300
                    tabs: for (i:Integer in [1..5]) {
                        Tab {
                            label: "tab{i}"
                            node: Text {
                                translateX: 40
                                translateY: 50
                                content: "Contents on tab {i}"
                                font: Font {
                                    name: "Sans serif"
                                    size: 32
                                }
                            }
                        }
                    }

                }
            ]

        }
    }

}