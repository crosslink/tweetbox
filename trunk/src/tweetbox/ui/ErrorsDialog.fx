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
import tweetbox.generic.component.ListBox;
import tweetbox.generic.component.listboxcellrenderer.SimpleCellRenderer;

/**
 * @author mnankman
 */

def height = 600;
def width = 600;

public function create(): Dialog {
    var nodeStyle = bind Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();
    var t1:Text;
    var t2:Text;
    var t3:Text;
    var t4:Text;

    var dlg:Dialog = Dialog {
        title: "Errors"
        width: width
        height: height
        content: [
            ListBox {
                translateX: 5
                translateY: 5
                width: width-10
                height: height-10
                model: bind model.errors
                cellRenderer: SimpleCellRenderer{}
                cellHeight:50
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

    var controller = FrontController.getInstance();
    controller.setError("error 1");

    var scene:Scene = Scene {
        content: [
            Button {
                translateX: 5
                translateY: 5
                width: 100
                label: "Errors"
                action: function() {
                     about.open(scene);
                }
            }
        ]

    }

    Stage {
        x:100 y:100 width:800 height:800
        onClose: function() {
            java.lang.System.exit(0);
        }
        scene: scene
    }
}
