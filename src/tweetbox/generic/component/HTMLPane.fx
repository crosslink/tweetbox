/*
 * TestJEditorPane.fx
 *
 * Created on 24-mrt-2009, 16:17:16
 */

package tweetbox.generic.component;

import javax.swing.JEditorPane;
import javax.swing.text.Document;
import javax.swing.event.HyperlinkListener;
import javax.swing.event.HyperlinkEvent;
import java.awt.Dimension;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.ext.swing.SwingComponent;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;

/**
 * @author mnankman
 */

public class HTMLPane extends CustomNode {
    public var width:Integer on replace {
        redimensionEditorPane();
    }

    public var height:Integer on replace {
        replaceEditorPaneHtml();
    }

    public var html:String on replace {
        replaceEditorPaneHtml();
    }

    public var onLinkClicked: function(url:String);
    public var onLinkEntered: function(url:String);
    public var onLinkExited: function(url:String);

    public var font:Font on replace {
        replaceEditorPaneFont();
    }

    public var fill:Color = Color.TRANSPARENT;

    var editorPane = new JEditorPane("text/html", html);

    function redimensionEditorPane(): Void {
        editorPane.setPreferredSize(new Dimension(width, height));
    }

    function replaceEditorPaneHtml(): Void {
        if (html != null) {
            editorPane.setContentType("text/html");
            editorPane.setText(html);
        }
    }

    function replaceEditorPaneFont(): Void {
        if (font != null) {
            editorPane.setFont(font.impl_getAWTFont());
        }
    }

    public override function create(): Node {
        editorPane.addHyperlinkListener(
            HyperlinkListener {
                override function hyperlinkUpdate(e:HyperlinkEvent) {
                    if (e.getEventType() == HyperlinkEvent.EventType.ACTIVATED)
                        onLinkClicked(e.getURL().toString())
                    else if (e.getEventType() == HyperlinkEvent.EventType.ENTERED)
                        onLinkEntered(e.getURL().toString())
                    else if (e.getEventType() == HyperlinkEvent.EventType.EXITED)
                        onLinkExited(e.getURL().toString())
                }
            }
        );

        editorPane.setEditable(false);
        editorPane.setOpaque(false);
        editorPane.setBackground(fill.getAWTColor());

        redimensionEditorPane();
        replaceEditorPaneFont();

        return SwingComponent.wrap(editorPane);
    }
}

public function run() {
    def stage = Stage {
        x: 100
        y: 100
        width: 800
        height: 400
        scene: Scene {
            content: [
                Rectangle {
                    translateY: 50
                    translateX: 50
                    width: 101
                    height: 101
                    stroke: Color.BLACK
                    fill: Color.LIGHTGREY
                },
                HTMLPane {
                    width: 100
                    height: 100
                    translateY: 51
                    translateX: 51
                    font: Font {
                        name: "Verdana"
                        size: 14
                    }
                    html: "<strong>bold</strong>\n<em>emphasized</em>\nnormal\n<a href=\"http://www.tweetbox.org\">link</a>"
                    onLinkClicked: function(url:String) {
                        println("link [{url}] clicked")
                    }
                    onLinkEntered: function(url:String) {
                        println("link [{url}] entered")
                    }
                    onLinkExited: function(url:String) {
                        println("link [{url}] exited")
                    }
                }
            ]

        }
    }
}