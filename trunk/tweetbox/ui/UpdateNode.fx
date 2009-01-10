/*
 * ConfigView.fx
 *
 * Created on 2-nov-2008, 23:15:12
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.layout.*;
import javafx.ext.swing.SwingLabel;
import javafx.ext.swing.SwingTextField;
import javafx.ext.swing.SwingComponent;
import javafx.scene.effect.Reflection;

import com.javafxpert.custom_node.*;
import java.lang.System;

import tweetbox.model.Model;
import tweetbox.control.FrontController;

import javax.swing.JTextArea;

/**
 * @author mnankman
 */
public class UpdateNode extends CustomNode {
    public var text:String on replace {
        updateTextArea.setText(text);
    }
    
    var updateTextArea = new JTextArea(3,55);
    
    public override function create(): Node {
        updateTextArea.setText(text);
        updateTextArea.setLineWrap(true);
        updateTextArea.setWrapStyleWord(true);
        return HBox {
            var model = Model.getInstance();
            content: [
                SwingComponent.wrap(updateTextArea),
                VBox {
                    translateX: 20
                    spacing: 10
                    content: [
                        ButtonNode {
                            title: "send"
                            imageURL: "{__DIR__}icons/accept.png"
                            action:
                            function():Void {
                                FrontController.getInstance().sendUpdate(updateTextArea.getText());
                            }
                        },
                        ButtonNode {
                            title: "short"
                            imageURL: "{__DIR__}icons/link.png"
                            action:
                            function():Void {
                                
                            }
                        }
                    ]
                    
                }    

            ]

        };
    }
}
