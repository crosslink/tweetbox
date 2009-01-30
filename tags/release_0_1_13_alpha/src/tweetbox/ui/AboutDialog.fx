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
import javafx.stage.*;
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
    public var width = 400;
    public var height = 240;
    public var visible = false;
    public var modal = false;

    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();
    var nodeStyle = Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();
    var closeButton:Button;
    var t1:Text;
    var t2:Text;
    var t3:Text;
    var t4:Text;
    
    var content = Group {
        content: [
            Rectangle {
                translateX:0
                translateY:0
                stroke: nodeStyle.APPLICATION_BACKGROUND_STROKE
                strokeWidth: 3
                x:0 y:0
                width: bind width - 2
                height: bind height - 2
                fill:nodeStyle.APPLICATION_BACKGROUND_FILL

            },
            Group {
                content: [
                    Rectangle {
                        x:3
                        y:3
                        width: bind width - 6
                        height: bind 20
                        fill:nodeStyle.APPLICATION_TITLEBAR_FILL
                    },
                    Text {
                        translateY: 15
                        translateX: 10
                        content: "About TweetBox"
                        fill: nodeStyle.APPLICATION_TITLEBAR_TEXT_FILL
                        font: nodeStyle.APPLICATION_TITLEBAR_TEXT_FONT
                    }
                ]
            },
            VBox {
                translateX: 0
                translateY: 40
                content: [
                    t1 = Text {
                        translateX: bind ((width - t1.layoutBounds.width) / 2)
                        content: "TweetBox {model.appInfo.major}.{model.appInfo.minor}.{model.appInfo.build} {model.appInfo.info}"
                    },
                    t2 = Text {
                        translateX: bind ((width - t2.layoutBounds.width) / 2)
                        translateY: 20
                        content: "powered by: {model.appInfo.javafx}, {model.appInfo.libraries}"
                    },
                    t3 = Text {
                        translateX: bind ((width - t3.layoutBounds.width) / 2)
                        translateY: 20
                        content: "licence: {model.appInfo.licence}"
                    },
                    t4 = Text {
                        translateX: bind ((width - t4.layoutBounds.width) / 2)
                        translateY: 30
                        wrappingWidth: width - 10
                        content: "Running on {model.appInfo.osName} {model.appInfo.osVersion}, Java Runtime {model.appInfo.javaVersion}, {model.appInfo.vmVendor} {model.appInfo.vmName} {model.appInfo.vmVersion}"
                    },
                    closeButton = Button {
                        translateY: 50
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
        style: StageStyle.TRANSPARENT
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
        onClose: function() {
            java.lang.System.exit(0);
        }
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
