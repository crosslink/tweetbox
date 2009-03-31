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

public var BACKGROUND = LinearGradient {
            startX:0 startY:0 endX:0 endY: 1
            stops: [
                Stop { offset:0 color:Color.rgb(41,170,210)},
                Stop { offset:1 color:Color.rgb(245,245,245) },
            ]
        }

public function create():Theme {
    return Theme {
        NAME: "The Mesh"

        APPLICATION_BACKGROUND_FILL : BACKGROUND;

        APPLICATION_BACKGROUND_STROKE : MESH_BLUE;

        // tweetsview styles
        TWEETSVIEW_TITLEBAR_FILL : MESH_RED;
        TWEETSVIEW_STROKE : MESH_RED;
        TWEETSVIEW_FILL : Color.TRANSPARENT;
        TWEETSVIEW_TITLEBAR_TEXT_FILL : Color.WHITE;
        TWEETSVIEW_TITLEBAR_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
            embolden: true
        }

        // title bar styles
        APPLICATION_TITLEBAR_FILL : MESH_RED;
        APPLICATION_TITLEBAR_TEXT_FILL : Color.WHITE;
        APPLICATION_TITLEBAR_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
            embolden: true
        }

        // status bar styles
        APPLICATION_STATUSBAR_FILL : Color.rgb(255,255,255);
        APPLICATION_STATUSBAR_TEXT_FILL : MESH_BLUE;
        APPLICATION_STATUSBAR_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
            embolden: true
        }

        // update styles
        UPDATEBOX_FILL : Style.adjustOpacity(MESH_BLUE, 0.8);
        UPDATEBOX_STROKE : MESH_RED;
        UPDATE_FILL : Color.rgb(255,255,255);
        UPDATEBOX_DMTO_TEXT_BG_FILL : MESH_RED;
        UPDATEBOX_DMTO_TEXT_FILL : Color.WHITE;
        UPDATE_TEXT_FILL : Color.BLACK;
        UPDATE_LINK_FILL : Color.BLUE;
        UPDATE_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
        }
        UPDATECOUNTER_TEXT_FILL : Color.WHITE;
        UPDATECOUNTER_TOOMUCH_TEXT_FILL : Color.RED;
        UPDATECOUNTER_TEXT_FONT : Font {
            name: "Verdana"
            size: 20
        }

        // group node styles
        GROUPNODE_TEXT_FILL : Color.WHITE;
        GROUPNODE_TEXT_FONT : Font {
            name: "Verdana"
            size: 28
        }

        // alert box styles
        ALERT_TEXT_FILL : Color.BLACK;
        ALERT_TEXT_FONT : Font {
            name: "Verdana"
            size: 12
            embolden: true
        }

        // button styles
        BUTTON_STROKE : Style.buttonStrokeGradient(MESH_RED);
        BUTTON_FILL : Style.buttonFillGradient(MESH_RED);
        BUTTON_TEXT_FILL : Color.WHITE;
        BUTTON_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
        }

        // scroll bar styles
        SCROLLBAR_TRACK_FILL : Color.WHITE;
        VERTICALSCROLLBAR_THUMB_FILL : Style.scrollbarThumbFillGradient(MESH_RED, 1);
        HORIZONTALSCROLLBAR_THUMB_FILL : Style.scrollbarThumbFillGradient(MESH_RED, 0);

        // tab navigator styles
        TAB_TEXT_FILL : Color.WHITE;
        TAB_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
        };
        TAB_FILL : Style.buttonFillGradient(MESH_RED);
        TAB_STROKE : Style.buttonStrokeGradient(MESH_RED);
        TABVIEW_STROKE : MESH_RED;


        // Dialog styles
        DIALOG_FILL : BACKGROUND;
        DIALOG_STROKE : MESH_BLUE;
        DIALOG_TEXT_FILL : Color.BLACK;
        DIALOG_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
        }
        DIALOG_TITLEBAR_FILL : Color.rgb(255,255,255);
        DIALOG_TITLEBAR_TEXT_FILL : MESH_BLUE;
        DIALOG_TITLEBAR_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
            embolden: true
        }

        // error styles
        ERROR_FILL : MESH_RED;
        ERROR_TEXT_FILL : Color.WHITE;
        ERROR_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
            embolden: true
        }
    }
}

