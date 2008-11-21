/*
 * Styles.fx
 *
 * Created on 7-nov-2008, 9:55:37
 */

package tweetbox.ui.style;

import javafx.scene.paint.*;
import javafx.scene.*;

/**
 * @author mnankman
 */

public class MeshStyle {
    public static attribute MESH_BLUE:Color = Color.rgb(41,170,210);
    public static attribute MESH_RED:Color = Color.rgb(215,31,58);
    
    public attribute APPLICATION_BACKGROUND_FILL:Paint = LinearGradient {
        startX:0 startY:0 endX:0 endY: 1
        stops: [
            Stop { offset:0 color:Color.rgb(41,170,210,0.9)},
            Stop { offset:1 color:Color.rgb(245,245,245,0.9) },
        ]
    }
    
    public attribute APPLICATION_BACKGROUND_STROKE: Paint = MESH_BLUE;
    
    // scroll bar styles
    public attribute SCROLLBAR_TRACK_FILL: Paint = Color.WHITE;
    public attribute SCROLLBAR_THUMB_FILL: Paint = MESH_RED;

    // title bar styles
    public attribute APPLICATION_TITLEBAR_FILL: Paint = MESH_RED;
    public attribute APPLICATION_TITLEBAR_TEXT_FILL: Paint = Color.WHITE;
    public attribute APPLICATION_TITLEBAR_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
        style: FontStyle.BOLD
    }
    
    // status bar styles
    public attribute APPLICATION_STATUSBAR_FILL: Paint = Color.rgb(255,255,255);
    public attribute APPLICATION_STATUSBAR_TEXT_FILL: Paint = MESH_BLUE;
    public attribute APPLICATION_STATUSBAR_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
        style: FontStyle.BOLD
    }
    
    // update styles
    public attribute UPDATE_FILL: Paint = Color.rgb(255,255,255);
    public attribute REPLY_FILL: Paint = Color.rgb(255,200,200);
    public attribute DIRECTMESSAGE_FILL: Paint = Color.rgb(200,255,200);
    public attribute MYUPDATE_FILL: Paint = Color.rgb(200,200,255);
    public attribute UPDATE_TEXT_FILL: Paint = Color.BLACK;
    public attribute UPDATE_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
    }

    // group button styles
    public attribute GROUPBUTTON_BORDER_COLOR: Paint = MESH_RED;
    public attribute GROUPBUTTON_HOVER_FILL: Paint = Color.rgb(200,200,255);
    public attribute GROUPBUTTON_SELECTED_FILL: Paint = Color.WHITE;
    public attribute GROUPBUTTON_TEXT_FILL: Paint = MESH_RED;
    public attribute GROUPBUTTON_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
        style: FontStyle.PLAIN
    }
    
}
