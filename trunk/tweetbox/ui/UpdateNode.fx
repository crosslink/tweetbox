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

import com.javafxpert.custom_node.*;
import java.lang.System;

import tweetbox.model.Model;
import tweetbox.control.FrontController;

import javax.swing.JTextArea;

/**
 * @author mnankman
 */
public class UpdateNode extends CustomNode {
    
    public function create(): Node {
        var updateTextArea = new JTextArea(3,40);
        
        return HBox {
            var model = Model.getInstance();
            var updateRef:TextField;
            content: [
                ComponentView {
                    component: Component.fromJComponent(updateTextArea);
                },
                MenuNode {
                    translateX: 10
                    buttons: [
                        ButtonNode {
                            title: "send update"
                            imageURL: "{__DIR__}icons/accept.png"
                            action:
                            function():Void {
                                FrontController.getInstance().sendUpdate(updateTextArea.getText());
                                updateTextArea.setText("");
                            }
                        }
                    ]
                }
            ]

        };
    }
}
