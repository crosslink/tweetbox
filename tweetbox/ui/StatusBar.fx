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
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Line;
import javafx.scene.text.Text;
import tweetbox.ui.style.Style;
import tweetbox.model.Model;
import tweetbox.model.State;
import java.lang.System;

/**
 * @author mnankman
 */

public class StatusBar extends CustomNode {
    
    var nodeStyle = Style.getApplicationStyle();
    var stateDescriptions:String[] = [
        "ready",
        "error",
        "retrieving updates...",
        "retrieving replies...",
        "retrieving direct messages...",
        "retrieving search results...",
        "sending update...",
        "yeah, go ahead, shut me down again"
    ];
    var statusTextNodes:Node[] = [
        for (i:Integer in [State.READY..State.EXITING]) {
            Text {
                id: "{i}"
                content: bind stateDescriptions[i]  
                fill: nodeStyle.APPLICATION_STATUSBAR_TEXT_FILL
                font: nodeStyle.APPLICATION_STATUSBAR_TEXT_FONT
            }
        }                        
    ];
    var textContainer:Group;
    
    public var width:Number;
    public var height:Number;
    
    public var state:Integer on replace {
        textContainer.content = [statusTextNodes[state]];
        System.out.println("state changed to: {state} ({stateDescriptions[state]})");
        System.out.println("visible text node: {statusTextNodes[state].id}");
        fadeTimeline.play();
    }

  /**
   * This var is interpolated by a Timeline, and the opacity
   * var of this DeckNode class is bound to it.  This helps
   * enable the fade-in effect.
   */
   var opa:Number;

  /**
   * Override the opacity var so that it can be bound to the
   * opa var that is interpolated by a Timeline
   */
  override var opacity = bind opa;

  /**
   * A Timeline to control the fade-in behavior
   */
    var fadeTimeline =
    Timeline {
        keyFrames: [
            KeyFrame {
                time: bind 10ms
                values: [opa => 1.0 tween Interpolator.LINEAR]
            }
        ]
    };

    public override function create(): Node {
        return Group {
            var textRef:Node;
            content: [
                Rectangle { 
                    x:0 
                    y:0
                    width: bind width - 2
                    height: bind 20 
                    fill:nodeStyle.APPLICATION_STATUSBAR_FILL
                },
                Line {
                    startX: 10
                    endX: bind width - 10;
                    stroke: nodeStyle.APPLICATION_STATUSBAR_TEXT_FILL
                },
                textContainer = Group {
                    translateY: 15
                    translateX: bind (width - statusTextNodes[state].layoutBounds.width)/2;
                }
            ]

        };
    }


}