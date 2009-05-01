/*
 * Dialog.fx
 *
 * Created on 19-mrt-2009, 21:05:00
 */

package tweetbox.generic.component;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.stage.*;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;
import javafx.scene.paint.Color;
import javafx.animation.*;

import java.awt.Toolkit;
import java.awt.Dimension;

import tweetbox.generic.layout.FlowBox;
import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */
public class Dialog extends CustomNode {

    public-init var title:String;
    
    public var owner: Scene on replace {
        x = (owner.width - width) / 2;
        y = (owner.height - height) / 2;
        if (x<0) x = 10;
        if (y<0) y = 10;
    }

    public var width:Integer;
    public var height:Integer;

    public var onOpen: function():Void;
    public var onClose: function():Void;

    var x:Integer = 10;
    var y:Integer = 10;


    var nodeStyle = bind Style.getApplicationStyle();

    public var content: Node[];
    public var buttons: Button[];

    var buttonBox: FlowBox;

    var opacityValue:Number = 0.0;
    public var fade = Timeline {
        keyFrames: [
            KeyFrame {
                time: bind 500ms
                values: [
                    opacityValue => 0.7 tween Interpolator.LINEAR,
                ]
            }
        ]
    };

    public override function create(): Node {
        return Group {
            content: [
                // draw a mouse blocking, transparant screen in front of the owner
                Rectangle {
                    fill: Color.BLACK
                    opacity: bind opacityValue
                    translateX:0
                    translateY:0
                    width: bind owner.width
                    height: bind owner.height
                    visible: true
                    blocksMouse: true
                },

                // The group containing the entire dialog
                Group {
                    translateX: bind x
                    translateY: bind y
                    content: [
                        // the dialog frame
                        Rectangle {
                            cache: true
                            translateX:0
                            translateY:0
                            stroke: bind nodeStyle.DIALOG_STROKE
                            strokeWidth: 3
                            x:0 y:0
                            width: bind width - 2
                            height: bind height - 2
                            fill: bind nodeStyle.DIALOG_FILL

                        },

                        // the dialog title bar
                        Group {
                            content: [
                                Rectangle {
                                    x:3
                                    y:3
                                    width: bind width - 7
                                    height: 20
                                    fill: bind nodeStyle.DIALOG_TITLEBAR_FILL
                                },
                                Text {
                                    translateY: 15
                                    translateX: 10
                                    content: title
                                    fill: bind nodeStyle.DIALOG_TITLEBAR_TEXT_FILL
                                    font: bind nodeStyle.DIALOG_TITLEBAR_TEXT_FONT
                                }
                            ]
                        },

                        // the dialog contents
                        Group {
                            cache: true
                            translateX: 0
                            translateY: 40
                            content: bind content
                        }

                        // the dialog  buttons
                        buttonBox = FlowBox {
                            width: bind width
                            translateY: bind height - buttonBox.layoutBounds.height - 5
                            translateX: bind (width - buttonBox.layoutBounds.width) / 2
                            content: buttons
                        }
                    ]

                }
           ]
        }
    }

    public function open(scene:Scene): Void {
        onOpen();
        insert this into scene.content;
        this.owner = scene;
        fade.rate = 1.0;
        fade.playFromStart();
        buttonBox.invalidLayout = true;
        this.visible = true;
    }

    public function close(): Void {
        onClose();
        this.visible = false;
        if (owner != null) delete this from owner.content;
        owner = null;
    }

}

public function run() {
    var dlg:Dialog = Dialog {
        x:100
        y:100
        width: 300
        height: 170
        visible: false

        content: [
            Text {content: "The contents of this dialog"}
        ]

        buttons: [
            Button {
                label: "close"
                action: function() {
                     dlg.close();
                }
            }
        ]

    };

    var scene:Scene = Scene {
        content: [
            Button {
                translateX: 5
                translateY: 5
                width: 100
                label: "Show dialog"
                action: function() {
                     dlg.open(scene);
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
