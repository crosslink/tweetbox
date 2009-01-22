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
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.shape.Rectangle;


import tweetbox.generic.component.Button;

import tweetbox.model.Model;
import tweetbox.control.FrontController;
import tweetbox.ui.style.Style;

import javax.swing.JTextArea;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import java.lang.Math;

def MAX_TWEET_LENGTH:Integer = 140;


/**
 * @author mnankman
 */
public class UpdateNode extends CustomNode {
    public var text:String on replace {
        updateTextArea.setText(text);
    }

    public var width:Number on replace {
        updateTextArea.setColumns(Math.max(width/10, 40));
    }

    var nodeStyle = Style.getApplicationStyle();
    
    var updateTextArea = new JTextArea(text, 2, Math.max(width/10, 40));
    var textLength:Integer = updateTextArea.getDocument().getLength();
    var maxLengthExceeded:Boolean = bind textLength > MAX_TWEET_LENGTH;

    var keyListener:KeyListener = KeyListener {
            public override function keyTyped(keyEvent:KeyEvent) {
                textLength = updateTextArea.getDocument().getLength();

            }

            public override function keyPressed(keyEvent:KeyEvent) {
                if (keyEvent.VK_ENTER == keyEvent.getKeyCode() and updateTextArea.hasFocus()) {
                    keyEvent.consume();
                    sendUpdate();
                }
            }

            public override function keyReleased( keyEvent:KeyEvent) {}

        }

    var updateBox:Node;
    
    public override function create(): Node {
        updateTextArea.setText(text);
        updateTextArea.setLineWrap(true);
        updateTextArea.setWrapStyleWord(true);
        updateTextArea.addKeyListener(keyListener);
    
        return Group {
            content: [
                Rectangle {
                    stroke: nodeStyle.MESH_BLUE
                    strokeWidth: 3
                    width: bind updateBox.layoutBounds.width + 10
                    height: bind updateBox.layoutBounds.height + 10
                    fill:nodeStyle.MESH_BLUE
                },
                updateBox = VBox {
                    translateX: 5
                    translateY: 5
                    content: [
                        HBox {
                            spacing: 10
                            content: [
                                SwingComponent.wrap(updateTextArea),
                                SwingLabel {
                                    text: bind "{MAX_TWEET_LENGTH - textLength}"
                                    font: Font {
                                        name: "Sans serif"
                                        size: 20
                                    }
                                    foreground: bind if (maxLengthExceeded) Color.RED else Color.BLACK
                                }
                            ]
                        },
                        Button {
                            translateY: 5
                            label: "update"
                            imageURL: "{__DIR__}icons/accept.png"
                            action: sendUpdate
                        }
                    ]
                }
            ]
        };
    }

    function sendUpdate(): Void {
        FrontController.getInstance().sendUpdate(updateTextArea.getText());
    }
}

function run(): Void {
    Stage {
        width: 600
        height: 150
        scene: Scene {
            fill: Color.GREY
            content: [
                UpdateNode {
                    translateX: 5
                    translateY: 5
                    text: bind Model.getInstance().updateText
                }
            ]
        }
    }
}