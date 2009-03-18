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
import javafx.geometry.Point2D;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;

import tweetbox.generic.component.Button;

import tweetbox.model.Model;
import tweetbox.control.FrontController;
import tweetbox.ui.style.Style;

import javax.swing.JTextArea;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import javax.swing.event.DocumentListener;
import javax.swing.event.DocumentEvent;

import java.lang.Math;

def MAX_TWEET_LENGTH:Integer = 140;


/**
 * @author mnankman
 */
public class UpdateNode extends CustomNode {
    public var text:String on replace {
        updateTextArea.setText(text);
        textLength = updateTextArea.getDocument().getLength();
    }

    public var width:Number on replace {
        //updateTextArea.setColumns(Math.max(width/10, 40));
    }
    var model = Model.getInstance();
    var control = FrontController.getInstance();

    var nodeStyle = bind Style.getApplicationStyle();
    
    var updateTextArea = new JTextArea(text, 5, 30);
    var textLength:Integer = updateTextArea.getDocument().getLength();
    var maxLengthExceeded:Boolean = bind textLength > MAX_TWEET_LENGTH;

    var keyListener:KeyListener = KeyListener {
        public override function keyPressed(ke:KeyEvent) {
            if (ke.VK_ENTER == ke.getKeyCode() and updateTextArea.hasFocus()) {
                ke.consume();
                sendUpdate();
            }
        }
        public override function keyTyped(ke:KeyEvent) {}
        public override function keyReleased(ke:KeyEvent) {}
    }

    var documentListener:DocumentListener = DocumentListener {
        public override function changedUpdate(de:DocumentEvent) {
            textLength = de.getDocument().getLength();
        }

        public override function insertUpdate(de:DocumentEvent) {
            textLength += de.getLength();
        }

        public override function removeUpdate(de:DocumentEvent) {
            textLength -= de.getLength();
        }
    }


    var updateBox:Node;
    var counterLabel:Node;
    
    public override function create(): Node {
        updateTextArea.setText(text);
        updateTextArea.setLineWrap(true);
        updateTextArea.setWrapStyleWord(true);
        updateTextArea.addKeyListener(keyListener);
        updateTextArea.getDocument().addDocumentListener(documentListener);
    
        return Group {
            blocksMouse:true;
            content: [
                Rectangle {
                    strokeWidth: 3
                    width: bind updateBox.layoutBounds.width + 10
                    height: bind updateBox.layoutBounds.height + 10
                    fill: bind nodeStyle.UPDATEBOX_FILL
                    stroke: bind nodeStyle.UPDATEBOX_STROKE
                },
                updateBox = VBox {
                    translateX: 5
                    translateY: 5
                    content: [
                        Group {
                            visible: bind model.directMessageMode
                            content: [
                                Rectangle {
                                    width: 329
                                    height: 18
                                    fill: bind nodeStyle.UPDATEBOX_DMTO_TEXT_BG_FILL
                                }
                                Text {
                                    translateY: 12
                                    translateX: 2
                                    fill: bind nodeStyle.UPDATEBOX_DMTO_TEXT_FILL
                                    content: bind "dm to: {model.directMessageReceiver.user.getName()} ({model.directMessageReceiver.screenName})"
                                }
                            ]
                        },
                        SwingComponent.wrap(updateTextArea),
                        HBox {
                            spacing: 5
                            content: [
                                Button {
                                    translateY: 5
                                    label: "update"
                                    imageURL: "{__DIR__}icons/accept.png"
                                    action: sendUpdate
                                },
                                Button {
                                    translateY: 5
                                    label: "shrink"
                                    imageURL: "{__DIR__}icons/link.png"
                                    action: shrink
                                },
                                Button {
                                    translateY: 5
                                    label: "hide"
                                    imageURL: "{__DIR__}icons/cancel.png"
                                    action: cancel
                                },
                                counterLabel = Text {
                                    translateX: 60
                                    translateY: 20
                                    textAlignment: TextAlignment.RIGHT;
                                    content: bind "{MAX_TWEET_LENGTH - textLength}"
                                    font: bind nodeStyle.UPDATECOUNTER_TEXT_FONT
                                    fill: bind 
                                        if (maxLengthExceeded)
                                            nodeStyle.UPDATECOUNTER_TOOMUCH_TEXT_FILL
                                        else
                                            nodeStyle.UPDATECOUNTER_TEXT_FILL
                                }

                            ]
                        }
                    ]
                }
            ]
        };
    }

    function sendUpdate(): Void {
        FrontController.getInstance().sendUpdate(updateTextArea.getText());
        updateTextArea.setText("");
        textLength = 0;
    }

    function shrink():Void {
        var result:String = "";
        var tokens:String[] = updateTextArea.getText().split("\\s");
        for (t:String in tokens) {
            if (t.startsWith("http") or t.startsWith("ftp")) {
                result = "{result} {control.shrinkUrl(t)}"
            }
            else {
                result = "{result} {t}"
            }
        }
        updateTextArea.setText(result);
        textLength = result.length();
    }

    function cancel(): Void {
        updateTextArea.setText("");
        textLength = 0;
        FrontController.getInstance().cancelUpdate();
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
