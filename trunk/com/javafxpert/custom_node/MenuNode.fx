
/*
 *  MenuNode.fx - 
 *  A custom node that functions as a menu
 *
 *  Developed 2008 by James L. Weaver (jim.weaver at lat-inc.com)
 *  to demonstrate how to create custom nodes in JavaFX
 */

package com.javafxpert.custom_node;
 
import javafx.scene.*;
import javafx.scene.effect.*;
import javafx.scene.layout.*;

public class MenuNode extends CustomNode { 

  /*
   * A sequence containing the ButtonNode instances
   */
    public var buttons:ButtonNode[];
    
  /**
   * Create the Node
   */
    public override function create():Node {
        HBox {
            spacing: 10
            content: buttons
            effect:
                Reflection {
                    fraction: 0.50
                    topOpacity: 0.8
                }
        }    
    }
}  