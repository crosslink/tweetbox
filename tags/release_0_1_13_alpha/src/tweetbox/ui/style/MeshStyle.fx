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
    
    // tweetsview styles
    public var TWEETSVIEW_TITLEBAR_FILL: Paint = MESH_RED;
    public var TWEETSVIEW_STROKE: Paint = MESH_RED;
    public var TWEETSVIEW_FILL: Paint = Color.TRANSPARENT;
    public var TWEETSVIEW_TITLEBAR_TEXT_FILL: Paint = Color.WHITE;
    public var TWEETSVIEW_TITLEBAR_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
        embolden: true
    }

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
    public var UPDATEBOX_FILL: Paint = Color.rgb(41,170,210, 0.8);
    public var UPDATEBOX_STROKE: Paint = MESH_RED;
    public var UPDATE_FILL: Paint = Color.rgb(255,255,255);
    public var UPDATEBOX_DMTO_TEXT_BG_FILL: Paint = MESH_RED;
    public var UPDATEBOX_DMTO_TEXT_FILL: Paint = Color.WHITE;
    public var UPDATE_TEXT_FILL: Paint = Color.BLACK;
    public var UPDATE_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
    }

    // alert box styles
    public var ALERT_TEXT_FILL: Paint = Color.BLACK;
    public var ALERT_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 12
        embolden: true
    }

    // button styles
    public var BUTTON_STROKE: Paint = LinearGradient {
        startX: 0 startY: 0 endX: 0 endY: 1
        stops: [
            Stop { offset: 0.0 color: MESH_RED },
            Stop { offset: 1.0 color: Color.rgb(255,61,88) },
        ]
    };

    public var BUTTON_FILL: Paint = LinearGradient {
        startX: 0 startY: 0 endX: 0 endY: 1
        stops: [
            Stop { offset: 0.0 color: Color.rgb(255,61,88) },
            Stop { offset: 0.4 color: MESH_RED },
            Stop { offset: 0.8 color: Color.rgb(236,52,79) },
            Stop { offset: 1.0 color: Color.rgb(217,33,60) },
        ]
    };
    public var BUTTON_TEXT_FILL: Paint = Color.WHITE;
    public var BUTTON_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
    }
    // scroll bar styles
    public var SCROLLBAR_TRACK_FILL: Paint = Color.WHITE;
    public var SCROLLBAR_THUMB_FILL: Paint = MESH_RED;

    
}
