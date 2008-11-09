/*
 * WrappingText.fx
 *
 * Created on 3-nov-2008, 14:37:48
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.geometry.Rectangle;
import javafx.scene.paint.*;
import javafx.scene.text.Text;
import javafx.ext.swing.ComponentView;
import javafx.ext.swing.Panel; 
import javafx.ext.swing.Label; 
import tweetbox.util.WrappingTextHelper;
import java.util.List;
import javafx.scene.Font;
import javafx.scene.layout.*;

/**
 * @author mnankman
 */
public class WrappingText extends CustomNode {
    
    public attribute text:String;
    
    public attribute width:Integer;
    public attribute height:Integer;
    
    public attribute font:Font;
    
    public function create(): Node {
        return Group {
            var wrappedContent:List = 
                WrappingTextHelper.wrapText(text, font.getAWTFont(), width);
            var numLines = bind wrappedContent.size();
            content: bind
                for (line:Integer in [0..numLines-1]) {
                    Text {
                        translateY: bind line * font.size
                        font: bind font
                        content: wrappedContent.get(line) as String
                    }
                }
        };
    }
}
