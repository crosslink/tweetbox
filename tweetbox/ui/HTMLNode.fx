/*
 * HTMLNode.fx
 *
 * Created on 17-nov-2008, 20:11:49
 */

package tweetbox.ui;

import javafx.ext.swing.SwingComponent;
import javafx.ext.swing.SwingLabel;
import javax.swing.JLabel;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.text.Font;
import javafx.scene.paint.Paint;

/**
 * @author mnankman
 */

public class HTMLNode extends CustomNode {
    
    /** the html content that this node must render. surrounding <html> tag can be omited */
    public var html:String on replace {
        htmlLabel.setText("<html><p width=\"{width}\">{html}</p></html>");
    }
    
    /** the base font to be used for this node */
    public var font:Font on replace {
        htmlLabel.setFont(new java.awt.Font(font.name, java.awt.Font.PLAIN, font.size))
    }
    
    /** the width of this node in pixels */
    public var width:Number on replace {
        htmlLabel.setSize(width, height)
    }
    
    /** the height of this node in pixels */
    public var height:Number on replace {
        htmlLabel.setSize(width, height)
    }
        
    var htmlLabel:JLabel = new JLabel();
    
    public override function create(): Node {
        htmlLabel.setText("<html><p width=\"{width}\">{html}</p></html>");
        htmlLabel.setFont(new java.awt.Font(font.name, java.awt.Font.PLAIN, font.size));
        htmlLabel.setSize(width, height);
        return Group {
            content: [
                SwingComponent.wrap(htmlLabel)
            ]

        };
    }
}