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

import tweetbox.model.Model;
import tweetbox.control.FrontController;
import tweetbox.generic.component.Button;
import tweetbox.generic.component.Dialog;
import tweetbox.ui.style.Style;
import tweetbox.generic.component.HTMLNode;

/**
 * @author mnankman
 */

def height = 240;
def width = 500;

public function create(): Dialog {
    var nodeStyle = bind Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();
    var t1:Text;
    var t2:Text;
    var t3:Text;
    var t4:Text;

    var dlg:Dialog = Dialog {
        title: "About TweetBox"
        width: width
        height: height
        content: [
            t1 = Text {
                translateX: bind ((width - t1.layoutBounds.width) / 2)
                content: "TweetBox {model.appInfo.major}.{model.appInfo.minor}.{model.appInfo.build} {model.appInfo.info}"
                font: bind nodeStyle.DIALOG_TEXT_FONT
                fill: bind nodeStyle.DIALOG_TEXT_FILL
            },
            t2 = Text {
                translateX: bind ((width - t2.layoutBounds.width) / 2)
                translateY: 20
                content: "powered by: {model.appInfo.javafx}, {model.appInfo.libraries}"
                font: bind nodeStyle.DIALOG_TEXT_FONT
                fill: bind nodeStyle.DIALOG_TEXT_FILL
            },
            t3 = Text {
                translateX: bind ((width - t3.layoutBounds.width) / 2)
                translateY: 40
                content: "licence: {model.appInfo.licence}"
                font: bind nodeStyle.DIALOG_TEXT_FONT
                fill: bind nodeStyle.DIALOG_TEXT_FILL
            },
            t4 = Text {
                translateX: bind ((width - t4.layoutBounds.width) / 2)
                translateY: 60
                wrappingWidth: width - 10
                content: "Running on {model.appInfo.osName} {model.appInfo.osVersion}, Java Runtime {model.appInfo.javaVersion}, {model.appInfo.vmVendor} {model.appInfo.vmName} {model.appInfo.vmVersion}"
                font: bind nodeStyle.DIALOG_TEXT_FONT
                fill: bind nodeStyle.DIALOG_TEXT_FILL
            }
        ]

        buttons : [
            Button {
                label: "Close"
                imageURL: "{__DIR__}icons/cancel.png"
                action: function():Void {
                    dlg.close();
                }
            }
        ]
    }

    return dlg;
}

public function run() {
    var about = create();
    
    var scene:Scene = Scene {
        content: [
            Button {
                translateX: 5
                translateY: 5
                width: 100
                label: "About TweetBox"
                action: function() {
                     about.open(scene);
                }
            }
        ]

    }

    Stage {
        x:100 y:100 width:800 height:400
        onClose: function() {
            java.lang.System.exit(0);
        }
        scene: scene
    }
}
