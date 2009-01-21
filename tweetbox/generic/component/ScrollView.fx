/*
 * TweetsView.fx
 *
 * Created on 31-okt-2008, 9:33:30
 */

package tweetbox.generic.component;

import javafx.scene.input.*;
import javafx.scene.*;
import javafx.scene.shape.*;
import javafx.animation.*;
import javafx.scene.transform.*;
import javafx.scene.effect.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
import tweetbox.model.*;
import javafx.scene.text.*;
import javafx.scene.image.*;
import javafx.ext.swing.*;
import java.lang.System;
import java.util.List;
import tweetbox.ui.style.Style;
import javafx.stage.Stage;
import javafx.scene.Scene;

/**
 * @author mnankman
 */
public class ScrollView extends CustomNode {

    public var height:Number;
    public var width:Number;
    public var scrollStepSize:Integer = 5;
    public var content: Node[];

    public var hasVerticalScrollBar:Boolean = true;
    public var hasHorizontalScrollBar:Boolean = true;

    var nodeStyle = Style.getApplicationStyle();

    var view:Node;

    var vertScrollBar:ScrollBar;
    var horScrollBar:ScrollBar;

    public override function create(): Node {
        return Group {
            blocksMouse:true
            content: [
                view = VBox {
                    transforms: bind [
                        Translate.translate(
                            if (hasHorizontalScrollBar) horScrollBar.scrollPosition else 0.0,
                            if (hasVerticalScrollBar) vertScrollBar.scrollPosition else 0.0)
                    ]
                    content: bind content
                },
                vertScrollBar =
                    if (hasVerticalScrollBar)
                        ScrollBar {
                            orientation: ScrollBar.ORIENTATION_VERTICAL
                            view: bind view
                            height: bind height
                            visible: bind (view.layoutBounds.height > height)
                            translateX: bind width
                        }
                    else null,
                horScrollBar = 
                    if (hasHorizontalScrollBar)
                        ScrollBar {
                            orientation: ScrollBar.ORIENTATION_HORIZONTAL
                            view: bind view
                            width: bind width
                            visible: bind (view.layoutBounds.width > width)
                            translateY: bind height
                        }
                    else null

            ]

            clip:
                Rectangle {
                    width: bind if (vertScrollBar.visible) width + vertScrollBar.layoutBounds.width else width
                    height: bind if (horScrollBar.visible) height + horScrollBar.layoutBounds.height else height
                }
                
            onMouseWheelMoved: function(e:MouseEvent):Void {
                vertScrollBar.scrollForward.stop();
                vertScrollBar.scrollBackwards.stop();
                vertScrollBar.scrollBy(e.wheelRotation * scrollStepSize);
            }
        };
    }
    
    
    public function scrollToTop() {
        vertScrollBar.scrollTo(0);
    }
}

function run(): Void {
    Stage {
        width: 400
        height: 400
        scene: Scene {
            fill: Color.WHITE
            content: [
                ScrollView {
                    translateX: 20
                    translateY: 20
                    width: 300
                    height: 300
                    content: bind for (i:Integer in [0..19]) {
                        Text {
                            translateY: i*25
                            translateX: i*25
                            content: "this is line {i}"
                        }
                    }

                }
            ]
        }
    }
}