/*
 * HTMLNode.fx
 *
 * Created on 17-nov-2008, 20:11:49
 */

package tweetbox.generic.component;

import javafx.ext.swing.SwingComponent;
import javafx.ext.swing.SwingLabel;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.text.Font;
import javafx.scene.paint.Paint;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.input.MouseEvent;

import javafx.scene.text.Text;
import javafx.scene.layout.HBox;
import javax.swing.JLabel;

import java.io.StringReader;

/**
 * @author mnankman
 */

public def htmlParser = new HTMLParser();


public class HTMLNode extends CustomNode {
    
    /** the html content that this node must render. surrounding <html> tag can be omited */
    public var html:String;
    
    /** the base font to be used for this node */
    public var font:Font = Font {
        name: "Verdana"
        size: 11
    };

    public var textColor:Color = Color.BLACK;
    public var linkColor:Color = Color.BLUE;

    /** the width of this node in pixels */
    public var width:Number;
    
    /** the height of this node in pixels */
    public var height:Number;

    public var onLinkClicked:function(url:String);

    var content:Node[] = [];

    public override function create(): Node {
        return HBox {
            spacing: 0
            content: parseHtml()
        };
    }

    
    function createLinkNode(content:String, url:String): Text {
        return Text {
            content: content
            font: font
            underline: true
            cursor: javafx.scene.Cursor.HAND
            fill: linkColor
            onMouseClicked: function(e:MouseEvent) {
                onLinkClicked(url);
            }
        };
    }
    
    public function parseHtml(): Node[] {
        var currentElement:Text = null;
        var elements:Node[] = [];
        var outliner:HTMLOutliner = HTMLOutliner {
            override function handleStartTag(tag, attributes, position):Void {
                var tagStr = tag.toString();
                if (tagStr=="strong") {
                    currentElement = Text {
                        font: Font {
                            name: font.name
                            size: font.size
                            embolden: true
                        }
                    }
                }
                else if (tagStr=="a") {
                    currentElement = createLinkNode("", attributes.toString().substring(5)); //the substring op is required to skip "href="
                }
                else {
                    currentElement = Text {
                        font: font
                        fill: textColor
                    }
                }
            }

            override function handleEndTag(tag, position): Void {
                insert currentElement into elements;
                currentElement = null;
            }

            override function handleText(text, position): Void {
                if (currentElement == null) {
                    insert Text {
                        font: font
                        fill: textColor
                        content: new String(text)
                    }
                    into elements;
                }
                else {
                    currentElement.content = new String(text);
                }
            }

            override function flush(): Void {
            }
        };
        
        if (html != null and outliner != null) {
            htmlParser.parse(html, outliner);
        }
        return elements;

    }


}

function run(): Void {
    var htmlNode:HTMLNode = HTMLNode {
        translateY:50
        width: 600
        height: 200
        html: "<em>emphasized text</em><br><strong>bold text</strong><br> normal text <a href=\"http://www.google.com\">link to google.com</a>"
        font: Font {
            name: "Sans serif"
            size: 11
        }
        onLinkClicked: function(url:String) {
            println("url = {url}");
        }
    };

    Stage {
        width: 800
        height: 200
        scene: Scene {
            fill: Color.WHITE
            content: [
                htmlNode
            ]
        }
    }
}