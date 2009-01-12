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

/**
 * @author mnankman
 */
public class ScrollView extends CustomNode {

  /*
   * Contains the height of the view in pixels.
   */
    public var height:Number;

  /*
   * Contains the width of the view in pixels.
   */
    public var width:Number;

    var nodeStyle = Style.getApplicationStyle();

  /*
   * The color or gradient of the vertical scrollbar.
   */
    var vertScrollbarFill:Paint = nodeStyle.SCROLLBAR_TRACK_FILL;
   
  /*
   * The color or gradient of the vertical scrollbar thumb.
   */
    var vertScrollbarThumbFill:Paint = nodeStyle.SCROLLBAR_THUMB_FILL;
   
  /*
   * The width (in pixels) of the vertical scrollbar.
   */
    public var vertScrollbarWidth:Integer = 14;

    public var scrollStepSize:Integer = 5;
    
    public var content: Node[];
    
    var thumbStartY = 0.0;
    var thumbEndY = 0.0;
    var scrollValue = 0.0;
    var thumb:Rectangle;
    var track:Rectangle;
    var scrollUpBtn:Rectangle;
    var scrollDownBtn:Rectangle;
    
    var view:Node;

    var vertScrollBar:ScrollBar;
    var horScrollBar:ScrollBar;

    public override function create(): Node {
        return Group {
            blocksMouse:true
            content: [
                view = VBox {
                    transforms: bind [Translate.translate(horScrollBar.scrollPosition, vertScrollBar.scrollPosition)]
                    content: bind content
                },
                vertScrollBar = ScrollBar {
                    orientation: ScrollBar.ORIENTATION_VERTICAL
                    view: bind view
                    height: bind height
                    visible: bind (view.layoutBounds.height > height)
                    translateX: bind width
                },
                horScrollBar = ScrollBar {
                    orientation: ScrollBar.ORIENTATION_HORIZONTAL
                    view: bind view
                    width: bind width
                    visible: bind (view.layoutBounds.width > width)
                    translateY: bind height
                }
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