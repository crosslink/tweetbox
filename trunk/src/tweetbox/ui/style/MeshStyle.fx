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
    
    public var APPLICATION_BACKGROUND_FILL = LinearGradient {
        startX:0 startY:0 endX:0 endY: 1
        stops: [
            Stop { offset:0 color:Color.rgb(41,170,210)},
            Stop { offset:1 color:Color.rgb(245,245,245) },
        ]
    }
    
    public var APPLICATION_BACKGROUND_STROKE = MESH_BLUE;
    
    // tweetsview styles
    public var TWEETSVIEW_TITLEBAR_FILL = MESH_RED;
    public var TWEETSVIEW_STROKE = MESH_RED;
    public var TWEETSVIEW_FILL = Color.TRANSPARENT;
    public var TWEETSVIEW_TITLEBAR_TEXT_FILL = Color.WHITE;
    public var TWEETSVIEW_TITLEBAR_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
        embolden: true
    }

    // title bar styles
    public var APPLICATION_TITLEBAR_FILL = MESH_RED;
    public var APPLICATION_TITLEBAR_TEXT_FILL = Color.WHITE;
    public var APPLICATION_TITLEBAR_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
        embolden: true
    }
    
    // status bar styles
    public var APPLICATION_STATUSBAR_FILL = Color.rgb(255,255,255);
    public var APPLICATION_STATUSBAR_TEXT_FILL = MESH_BLUE;
    public var APPLICATION_STATUSBAR_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
        embolden: true
    }
    
    // update styles
    public var UPDATEBOX_FILL = Color.rgb(41,170,210, 0.8);
    public var UPDATEBOX_STROKE = MESH_RED;
    public var UPDATE_FILL = Color.rgb(255,255,255);
    public var UPDATEBOX_DMTO_TEXT_BG_FILL = MESH_RED;
    public var UPDATEBOX_DMTO_TEXT_FILL = Color.WHITE;
    public var UPDATE_TEXT_FILL = Color.BLACK;
    public var UPDATE_LINK_FILL = Color.BLUE;
    public var UPDATE_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
    }
    public var UPDATECOUNTER_TEXT_FILL = Color.WHITE;
    public var UPDATECOUNTER_TOOMUCH_TEXT_FILL = Color.RED;
    public var UPDATECOUNTER_TEXT_FONT = Font {
        name: "Verdana"
        size: 20
    }

    // group node styles
    public var GROUPNODE_TEXT_FILL = Color.WHITE;
    public var GROUPNODE_TEXT_FONT = Font {
        name: "Verdana"
        size: 28
    }

    // alert box styles
    public var ALERT_TEXT_FILL = Color.BLACK;
    public var ALERT_TEXT_FONT = Font {
        name: "Verdana"
        size: 12
        embolden: true
    }

    // button styles
    public var BUTTON_STROKE = Style.buttonStrokeGradient(MESH_RED);
    public var BUTTON_FILL = Style.buttonFillGradient(MESH_RED);
    public var BUTTON_TEXT_FILL = Color.WHITE;
    public var BUTTON_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
    }

    // scroll bar styles
    public var SCROLLBAR_TRACK_FILL = Color.WHITE;
    public var VERTICALSCROLLBAR_THUMB_FILL = Style.scrollbarThumbFillGradient(MESH_RED, 1);
    public var HORIZONTALSCROLLBAR_THUMB_FILL = Style.scrollbarThumbFillGradient(MESH_RED, 0);

    // tab navigator styles
    public var TAB_TEXT_FILL = BUTTON_TEXT_FILL;
    public var TAB_TEXT_FONT = BUTTON_TEXT_FONT;
    public var TAB_FILL = BUTTON_FILL;
    public var TAB_STROKE = BUTTON_STROKE;
    public var TABVIEW_STROKE = MESH_RED;

    // Dialog styles
    public var DIALOG_FILL = APPLICATION_BACKGROUND_FILL;
    public var DIALOG_STROKE = APPLICATION_BACKGROUND_STROKE;
    public var DIALOG_TEXT_FILL = Color.BLACK;
    public var DIALOG_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
    }
    public var DIALOG_TITLEBAR_FILL = APPLICATION_TITLEBAR_FILL;
    public var DIALOG_TITLEBAR_TEXT_FILL = APPLICATION_TITLEBAR_TEXT_FILL;
    public var DIALOG_TITLEBAR_TEXT_FONT = APPLICATION_STATUSBAR_TEXT_FONT;
    
    // error styles
    public var ERROR_FILL = MESH_RED;
    public var ERROR_TEXT_FILL = Color.WHITE;
    public var ERROR_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
        embolden: true
    }

}
