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
import javafx.scene.shape.Rectangle;
import javafx.scene.layout.*;
import javafx.scene.paint.Paint;
import javafx.scene.paint.Color;
import javafx.scene.input.MouseEvent;
import javafx.animation.*;
import javafx.scene.image.*;

import tweetbox.ui.style.*;

/**
 * @author mnankman
 */

public class GroupButton extends CustomNode {
    
    var nodeStyle = Style.getApplicationStyle();
    
    public var width:Integer;
    public var height:Integer;
    
    public var caption:String;
    public var groupId:String;

    var _newUpdates:Integer;
    public var newUpdates:Integer on replace {
        _newUpdates = newUpdates;
    }
    
    var btnImage:Image;
    public var imageURL:String on replace {
        btnImage = Image {
            url: imageURL
        };
    }
   
    public var selected:Boolean = false on replace {
        fadeTimeline.play();
    }
    
    public var onSelected:function(id:String):Void;
    
    public var opacityValue:Number = 0;

    var fadeTimeline = Timeline {
        autoReverse: true
        keyFrames: [
            KeyFrame {
                time: 500ms
                values: [opacityValue => 0.8 tween Interpolator.LINEAR]
            }
        ]
    };

    public override function create(): Node {
        return Group {
            content: [
                Rectangle {
                    height: bind height
                    //fill: null;
                    //stroke: null;
                    visible: false;
                },
                Rectangle {
                    fill: bind nodeStyle.GROUPBUTTON_SELECTED_FILL
                    opacity: bind opacityValue
                    x:0 y:0 
                    width: bind width - 2
                    height: bind height - 10
                    arcWidth:20 
                    arcHeight:20
                    blocksMouse: true
                    
                    onMouseEntered: function(me:MouseEvent):Void {
                        fadeTimeline.play();
                    }
                    
                    onMouseExited: function(me:MouseEvent):Void {
                        fadeTimeline.play();
                        me.node.effect = null;
                    }
                    
                    onMouseClicked: function(me:MouseEvent):Void {
                        onSelected(id);
                        _newUpdates = 0;
                    }
                },
                Rectangle { 
                    fill: bind nodeStyle.GROUPBUTTON_SELECTED_FILL
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
                    stroke: nodeStyle.GROUPBUTTON_BORDER_COLOR
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
                            translateY: -12
                            translateX: 4
                            image: btnImage;
                        },
                        Text {
                            translateX: 10
                            content: bind "{caption}"
                            fill: nodeStyle.GROUPBUTTON_TEXT_FILL
                            font: nodeStyle.GROUPBUTTON_TEXT_FONT
                        },
                        Text {
                            translateX: 10
                            visible: bind (_newUpdates>0)
                            content: bind " ({_newUpdates})"
                            fill: nodeStyle.GROUPBUTTON_TEXT_FILL
                            font: nodeStyle.GROUPBUTTON_TEXT_FONT
                        }
                    ]

                },
                
                
                
            ]

        };
    }
}