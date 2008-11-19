/*
 * HTMLNode.fx
 *
 * Created on 17-nov-2008, 20:11:49
 */

package tweetbox.ui;

import javafx.ext.swing.Component;
import javafx.ext.swing.Label;
import javafx.ext.swing.ComponentView;
import javax.swing.JLabel;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.Font;
import javafx.scene.paint.Paint;

/**
 * @author mnankman
 */

public class HTMLNode extends CustomNode {
    
    /** the html content that this node must render. surrounding <html> tag can be omited */
    public attribute html:String on replace {
        htmlLabel.setText("<html><p width=\"{width}\">{html}</p></html>");
    }
    
    /** the base font to be used for this node */
    public attribute font:Font on replace {
        htmlLabel.setFont(font.getAWTFont())
    }
    
    /** the width of this node in pixels */
    public attribute width:Integer on replace {
        htmlLabel.setSize(width, height)
    }
    
    /** the height of this node in pixels */
    public attribute height:Integer on replace {
        htmlLabel.setSize(width, height)
    }
        
    private attribute htmlLabel:JLabel = new JLabel();
    
    public function create(): Node {
        htmlLabel.setText("<html><p width=\"{width}\">{html}</p></html>");
        htmlLabel.setFont(font.getAWTFont());
        htmlLabel.setSize(width, height);
        return Group {
            content: [
                ComponentView {
                    component: Component.fromJComponent(htmlLabel);
                }
            ]

        };
    }
}