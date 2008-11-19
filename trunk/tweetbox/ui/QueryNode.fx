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
import tweetbox.model.Model;
import tweetbox.model.State;
import com.javafxpert.custom_node.*;
import java.lang.System;
import tweetbox.control.FrontController;

/**
 * @author mnankman
 */
public class QueryNode extends CustomNode {
    
    private attribute queryRef:TextField;
    
    public function create(): Node {
        return HBox {
            var model = Model.getInstance();
            content: [
                ComponentView {
                    component: 
                    queryRef = TextField {
                        columns: 36
                        
                    }

                },
                MenuNode {
                    translateX: 10
                    buttons: [
                        ButtonNode {
                            title: "send query"
                            imageURL: "{__DIR__}icons/accept.png"
                            action:
                            function():Void {
                                FrontController.getInstance().search(queryRef.text);
                                queryRef.text = "";
                            }
                        }
                    ]
                }
            ]

        };
    }

    
    
}
