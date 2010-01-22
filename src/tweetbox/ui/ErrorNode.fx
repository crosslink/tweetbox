/*
 * ErrorNode.fx
 *
 * Created on 27-feb-2009, 16:34:48
 */

package tweetbox.ui;

import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import tweetbox.ui.style.Style;
import tweetbox.model.Model;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;

/**
 * @author mnankman
 */

public class ErrorNode extends CustomNode {
    var model = Model.getInstance();
    var nodeStyle = bind Style.getApplicationStyle();
    
    public-read var width = bind imageRef.layoutBounds.width + textRef.layoutBounds.width + 10;
    public var height = 16;

    var imageRef:Node;
    var textRef:Node;

    var iconURL = "{__DIR__}icons/bullet_error.png";

    public override function create(): Node {
        return Group {
            visible: bind model.isError
            content: [
                Rectangle {
                    x:0
                    y:0
                    width: bind width
                    height: height
                    fill: bind nodeStyle.ERROR_FILL
                },
                imageRef = ImageView {
                    blocksMouse: false;
                    translateX: 2
                    translateY: bind (height-imageRef.layoutBounds.height)/2
                    fitHeight: height*0.9
                    preserveRatio: true
                    image: Image {
                        url: iconURL
                    }
                    cursor: javafx.scene.Cursor.HAND;
                    onMouseClicked: onMouseClicked
                },
                textRef = Text {
                    translateX: bind (width - textRef.layoutBounds.width + imageRef.layoutBounds.width) / 2
                    translateY: bind height / 2 + 5
                    content: "error(s) occurred"//bind model.error
                    font: bind nodeStyle.ERROR_TEXT_FONT
                    fill: bind nodeStyle.ERROR_TEXT_FILL
                }
            ]
        };
    }
}