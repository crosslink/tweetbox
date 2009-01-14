/*
 * Styles.fx
 *
 * Created on 7-nov-2008, 9:55:37
 */

package tweetbox.ui.style;

import javafx.scene.paint.*;
import javafx.scene.*;
import javafx.scene.text.Font;

/**
 * @author mnankman
 */

public var MESH_BLUE:Color = Color.rgb(41,170,210);
public var MESH_RED:Color = Color.rgb(215,31,58);

public class MeshStyle {
    
    public var APPLICATION_BACKGROUND_FILL:Paint = LinearGradient {
        startX:0 startY:0 endX:0 endY: 1
        stops: [
            Stop { offset:0 color:Color.rgb(41,170,210)},
            Stop { offset:1 color:Color.rgb(245,245,245) },
        ]
    }
    
    public var APPLICATION_BACKGROUND_STROKE: Paint = MESH_BLUE;
    
    // scroll bar styles
    public var SCROLLBAR_TRACK_FILL: Paint = Color.WHITE;
    public var SCROLLBAR_THUMB_FILL: Paint = MESH_RED;

    // title bar styles
    public var APPLICATION_TITLEBAR_FILL: Paint = MESH_RED;
    public var APPLICATION_TITLEBAR_TEXT_FILL: Paint = Color.WHITE;
    public var APPLICATION_TITLEBAR_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
        embolden: true
    }
    
    // status bar styles
    public var APPLICATION_STATUSBAR_FILL: Paint = Color.rgb(255,255,255);
    public var APPLICATION_STATUSBAR_TEXT_FILL: Paint = MESH_BLUE;
    public var APPLICATION_STATUSBAR_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
        embolden: true
    }
    
    // update styles
    public var UPDATE_FILL: Paint = Color.rgb(255,255,255);
    public var REPLY_FILL: Paint = Color.rgb(255,200,200);
    public var DIRECTMESSAGE_FILL: Paint = Color.rgb(200,255,200);
    public var MYUPDATE_FILL: Paint = Color.rgb(200,200,255);
    public var UPDATE_TEXT_FILL: Paint = Color.BLACK;
    public var UPDATE_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
    }

    // group button styles
    public var GROUPBUTTON_BORDER_COLOR: Paint = MESH_RED;
    public var GROUPBUTTON_HOVER_FILL: Paint = Color.rgb(200,200,255);
    public var GROUPBUTTON_SELECTED_FILL: Paint = Color.WHITE;
    public var GROUPBUTTON_TEXT_FILL: Paint = MESH_RED;
    public var GROUPBUTTON_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 18
        embolden: true
    }
    
}