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
import javafx.ext.swing.ComponentView;
import javafx.ext.swing.Label;
import javafx.ext.swing.TextField;
import javafx.ext.swing.Component;
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
    public attribute text:String on replace {
        updateTextArea.setText(text);
    }
    
    private attribute updateTextArea = new JTextArea(3,40);
    
    public function create(): Node {
        updateTextArea.setText(text);
        updateTextArea.setLineWrap(true);
        updateTextArea.setWrapStyleWord(true);
        return HBox {
            var model = Model.getInstance();
            var updateRef:TextField;
            content: [
                ComponentView {
                    component: Component.fromJComponent(updateTextArea);
                },
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
