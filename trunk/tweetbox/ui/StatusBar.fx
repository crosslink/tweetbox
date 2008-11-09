/*
 * StatusBar.fx
 *
 * Created on 7-nov-2008, 15:08:11
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.animation.*;
import javafx.scene.Node;
import javafx.scene.geometry.Rectangle;
import javafx.scene.geometry.Line;
import javafx.scene.text.Text;
import tweetbox.ui.style.Style;
import tweetbox.model.Model;
import tweetbox.model.State;
import java.lang.System;

/**
 * @author mnankman
 */

public class StatusBar extends CustomNode {
    
    private attribute style = Style.getApplicationStyle();
    private attribute stateDescriptions:String[] = [
        "ready",
        "error",
        "retrieving tweets...",
        "retrieving search results...",
        "sending update...",
        "yeah, go ahead, shut me down again"
    ];
    private attribute statusTextNodes:Node[] = [
        for (i:Integer in [State.READY..State.EXITING]) {
            Text {
                id: "{i}"
                content: bind stateDescriptions[i]  
                fill: style.APPLICATION_STATUSBAR_TEXT_FILL
                font: style.APPLICATION_STATUSBAR_TEXT_FONT                 
            }
        }                        
    ];
    private attribute visibleTextNodeRef:Node;
    
    public attribute width:Integer;
    public attribute height:Integer;
    
    public attribute state:Integer on replace {
        visibleTextNodeRef = statusTextNodes[state];
        System.out.println("state changed to: " + state + " (" + stateDescriptions[state] + ")");
        System.out.println("visible text node: " + visibleTextNodeRef.id);
        fadeTimeline.start();
    }

  /**
   * This attribute is interpolated by a Timeline, and the opacity
   * attribute of this DeckNode class is bound to it.  This helps
   * enable the fade-in effect.
   */
   private attribute opa:Number;

  /**
   * Override the opacity attribute so that it can be bound to the
   * opa attribute that is interpolated by a Timeline
   */
  override attribute opacity = bind opa;

  /**
   * A Timeline to control the fade-in behavior
   */
    private attribute fadeTimeline =
    Timeline {
        keyFrames: [
            KeyFrame {
                time: bind 10ms
                values: [opa => 1.0 tween Interpolator.LINEAR]
            }
        ]
    };

    public function create(): Node {
        return Group {
            var textRef:Node;
            content: [
                Rectangle { 
                    x:0 
                    y:0
                    width: bind width - 2
                    height: bind 20 
                    arcWidth:20 
                    arcHeight:20
                    fill:style.APPLICATION_STATUSBAR_FILL                    
                },
                Line {
                    startX: 10
                    endX: bind width - 10;
                    stroke: style.APPLICATION_STATUSBAR_TEXT_FILL
                },
                Group {
                    translateY: 15
                    translateX: bind (width - visibleTextNodeRef.getWidth())/2;
                    content: bind visibleTextNodeRef
                }
            ]

        };
    }


}