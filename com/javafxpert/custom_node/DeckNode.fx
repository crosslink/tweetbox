/*
 *  DeckNode.fx - 
 *  A node that shows a deck of nodes one at a time.
 *
 *  Developed 2008 by James L. Weaver (jim.weaver at lat-inc.com)
 *  to demonstrate how to create custom nodes in JavaFX
 */

package com.javafxpert.custom_node;
 
import javafx.animation.*;
import javafx.lang.*;
import javafx.scene.*;

/**
 *  A node that shows a deck of nodes one at a time.  When the
 *  visibleNodeId attribute is assigned a value, the Node whose
 *  id is the same as the name becomes visible.  Note that the
 *  the id attribute of each Node must be assigned a unique name.
 *  This class also has an attribute in which a fade-in duration
 *  may be specified.
 */
public class DeckNode extends CustomNode { 
  /**
   * A sequence that contains the Node instances in this "deck"
   */
    public attribute content:Node[];

  /**
   * The id of the node that is to be visible
   */
    public attribute visibleNodeId:String on replace {
        var nodes = 
        for (node in content where node.id == visibleNodeId) node;
        visibleNodeRef = if (sizeof nodes > 0) nodes[0] else null;
        fadeTimeline.start(); 
    }
   
  /**
   * The amount of time to fade-in the new Node 
   */
    public attribute fadeInDur:Duration = 0ms;

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
                time: bind fadeInDur
                values: [
                            opa => 1.0 tween Interpolator.LINEAR,
                ]
            }
        ]
    };

  /**
   * A reference to the Node in the Node instances that is visible
   */
    private attribute visibleNodeRef:Node;
   
  /**
   * Create the Node
   */
    public function create():Node {
        Group {
            content: bind visibleNodeRef
        };
    }
}