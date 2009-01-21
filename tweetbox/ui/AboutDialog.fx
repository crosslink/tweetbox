/*
 * ConfigView.fx
 *
 * Created on 2-nov-2008, 23:15:12
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;

import java.awt.Toolkit;
import java.awt.Dimension;

import org.jfxtras.stage.JFXStage;

import tweetbox.model.Model;
import tweetbox.control.FrontController;
import tweetbox.generic.component.Button;
import tweetbox.ui.style.Style;
import tweetbox.generic.component.HTMLNode;

/**
 * @author mnankman
 */
public class AboutDialog {
    
    public var title = "TweetBox configuration";
    public var width = 320;
    public var height = 180;
    public var visible = false;
    public var modal = false;

    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    var nodeStyle = Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();
    var closeButton:Button;
    var t1:Text;
    var t2:Text;
    
    var content = Group {
        content: [
            Rectangle {
                stroke: nodeStyle.APPLICATION_BACKGROUND_STROKE
                x:0 y:0
                width: bind width
                height: bind height
                fill:nodeStyle.APPLICATION_BACKGROUND_FILL
            },
            VBox {
                translateX: 0
                translateY: 40
                content: [
                    t1 = Text {
                        translateX: bind ((width - t1.layoutBounds.width) / 2)
                        content: "TweetBox 0.1"
                    },
                    t2 = Text {
                        translateX: bind ((width - t2.layoutBounds.width) / 2)
                        translateY: 20
                        content: "powered by JavaFX 1.0, Twitter4J 1.1.2 & JFXtras 0.1.1b"
                    },
                    closeButton = Button {
                        translateY: 40
                        translateX: bind (width - closeButton.layoutBounds.width) / 2
                        label: "Close"
                        imageURL: "{__DIR__}icons/cancel.png"
                        action: function():Void {
                            visible = false;
                        }
                    },
                ]

            }
        ]
    }

    public var stage:JFXStage = JFXStage {
        alwaysOnTop: true
        x: bind (screenSize.width - width) / 2
        y: bind (screenSize.height - height) / 2
        title: "About TweetBox"
        width: width
        height: height
        resizable: false
        visible: bind visible;
        scene: Scene {
            content: bind content
        }

    };

}

public function run() {
    var about = AboutDialog {}
    Stage {
        x:100 y:300 width:500 height:300
        scene:Scene {
            content: [
                Button {
                    translateX: 100
                    translateY: 100
                    width: 100
                    label: "About TweetBox"
                    action: function() {
                         about.visible = true
                    }
                }
            ]

        }
    }
}
