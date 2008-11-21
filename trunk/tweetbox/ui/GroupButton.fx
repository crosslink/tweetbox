/*
 * GroupButton.fx
 *
 * Created on 21-nov-2008, 9:29:01
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.text.Text;
import javafx.scene.geometry.Rectangle;
import javafx.scene.layout.*;
import javafx.scene.paint.Paint;
import javafx.scene.paint.Color;
import javafx.input.MouseEvent;
import javafx.animation.*;
import javafx.scene.image.*;

import tweetbox.ui.style.*;

/**
 * @author mnankman
 */

public class GroupButton extends CustomNode {
    
    private attribute style = Style.getApplicationStyle();
    
    public attribute width:Integer;
    public attribute height:Integer;
    
    public attribute caption:String;
    public attribute groupId:String;

    private attribute _newUpdates:Integer;
    public attribute newUpdates:Integer on replace {
        _newUpdates = newUpdates;
    }
    
    private attribute btnImage:Image;
    public attribute imageURL:String on replace {
        btnImage = 
        Image {
            url: imageURL
        };
    }
   
    public attribute selected:Boolean = false on replace {
        if (selected) {
            selectedOpacityValue = 1
        } else {
            selectedOpacityValue = 0
        }
    }
    
    public attribute onSelected:function(id:String):Void;
    
    public attribute opacityValue:Number = 0;
    public attribute selectedOpacityValue:Number = 0;

    private attribute fadeTimeline = Timeline {
        toggle: true
        keyFrames: [
            KeyFrame {
                time: 500ms
                values: [opacityValue => 0.8 tween Interpolator.LINEAR]
            }
        ]
    };

    public function create(): Node {
        return Group {
            content: [
                Rectangle {
                    height: bind height
                    //fill: null;
                    //stroke: null;
                    visible: false;
                },
                Rectangle {
                    fill: bind style.GROUPBUTTON_SELECTED_FILL
                    opacity: bind opacityValue
                    x:0 y:0 
                    width: bind width - 2
                    height: bind height - 10
                    arcWidth:20 
                    arcHeight:20
                    blocksMouse: true
                    
                    onMouseEntered: function(me:MouseEvent):Void {
                        fadeTimeline.start();
                    }
                    
                    onMouseExited: function(me:MouseEvent):Void {
                        fadeTimeline.start();
                        me.node.effect = null;
                    }
                    
                    onMouseClicked: function(me:MouseEvent):Void {
                        onSelected(id);
                        _newUpdates = 0;
                    }
                },
                Rectangle { 
                    fill: bind style.GROUPBUTTON_SELECTED_FILL
                    visible: bind selected
                    stroke: null
                    x:0 y:0 
                    width: bind width - 2
                    height: bind height - 10
                    arcWidth:20 
                    arcHeight:20
                },
                Rectangle { 
                    fill: null
                    stroke: style.GROUPBUTTON_BORDER_COLOR
                    fill: null;
                    x:0 y:0 
                    width: bind width - 2
                    height: bind height - 10
                    arcWidth:20 
                    arcHeight:20
                },
                HBox {
                    translateY: bind height / 2
                    translateX: 5
                    content: [
                        ImageView {
                            translateY: -10
                            translateX: 5
                            image: bind btnImage;
                        },
                        Text {
                            translateX: 10
                            content: bind "{caption}"
                            fill: style.GROUPBUTTON_TEXT_FILL
                            font: style.GROUPBUTTON_TEXT_FONT
                        },
                        Text {
                            translateX: 10
                            visible: bind (_newUpdates>0)
                            content: bind " ({_newUpdates})"
                            fill: style.GROUPBUTTON_TEXT_FILL
                            font: style.GROUPBUTTON_TEXT_FONT
                        }
                    ]

                },
                
                
                
            ]

        };
    }
}