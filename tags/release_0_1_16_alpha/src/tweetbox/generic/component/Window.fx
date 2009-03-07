/*
 * AlertWindow.fx
 *
 * Created on 19-nov-2008, 14:36:17
 */

package tweetbox.generic.component;

import javafx.scene.Scene;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.stage.*;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;

import java.awt.Toolkit;
import java.awt.Dimension;

/**
 * @author mnankman
 */

public class Window {
    public var width:Integer;
    public var height:Integer;
    public var title:String = "untitled";
    public var resizable:Boolean = true;

    var screenSize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();

    public var scene:Scene;

    public var stage = Stage {
        title: bind title
        x: (screenSize.width - width) / 2
        y: (screenSize.height - height) / 2
        width: width
        height: height
        resizable: resizable
        visible: false;
        scene: scene
    };

    public function show() {
        stage.visible = true;
    }

    public function hide() {
        stage.visible = false;
    }

}

public function run() {
    var s:Scene = Scene {
        content: Rectangle {
            x: 10
            y: 10
            width: bind s.width - 30
            height: bind s.height - 30
            stroke: Color.BLACK
            fill: Color.RED
        }
    };

    var w:Window = Window {
        title: "Test"
        width: 200
        height: 200
        scene: s
    }
    w.show();
}