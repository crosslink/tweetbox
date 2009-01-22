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
    public var content:Node;

    public var hasVerticalScrollBar:Boolean = true;
    public var hasHorizontalScrollBar:Boolean = true;

    var nodeStyle = Style.getApplicationStyle();

    var vertScrollBar:ScrollBar;
    var horScrollBar:ScrollBar;

    var contentTranslateX:Number = bind if (hasHorizontalScrollBar) horScrollBar.scrollPosition else 0.0 on replace {
        content.translateX = contentTranslateX;
    };

    var contentTranslateY:Number = bind if (hasVerticalScrollBar) vertScrollBar.scrollPosition else 0.0on replace {
        content.translateY = contentTranslateY;
    };

    var showVerticalScrollBar:Boolean = bind (content.layoutBounds.height > height) on replace {
        if (not showVerticalScrollBar) {
            vertScrollBar.scrollTo(0);
        }
    };

    var showHorizontalScrollBar:Boolean = bind (content.layoutBounds.width > width)on replace {
        if (not showHorizontalScrollBar) {
            horScrollBar.scrollTo(0);
        }
    };

    public override function create(): Node {
        return Group {
            blocksMouse:true
            content: [
                content,
                vertScrollBar =
                    if (hasVerticalScrollBar)
                        ScrollBar {
                            orientation: ScrollBar.ORIENTATION_VERTICAL
                            view: content
                            height: bind height
                            visible: bind showVerticalScrollBar
                            translateX: bind width
                        }
                    else null,
                horScrollBar = 
                    if (hasHorizontalScrollBar)
                        ScrollBar {
                            orientation: ScrollBar.ORIENTATION_HORIZONTAL
                            view: content
                            width: bind width
                            visible: bind showHorizontalScrollBar
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
                    content: Group {
                        content: bind for (i:Integer in [0..19]) {
                            Text {
                                translateY: i*25
                                translateX: i*25
                                content: "this is line {i}"
                            }
                        }
                    }

                }
            ]
        }
    }
}