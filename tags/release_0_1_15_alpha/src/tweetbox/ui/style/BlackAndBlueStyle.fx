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

public var KULER1:Color = Color.rgb(196,228,225);
public var KULER2:Color = Color.rgb(84,178,219);
public var KULER3:Color = Color.rgb(2,5,13);
public var KULER4:Color = Color.rgb(28,100,122);
public var KULER5:Color = Color.rgb(238,253,255);

public var FILL1 = KULER5;
public var FILL2 = KULER1;
public var FILL3 = KULER4;
public var FILL4 = KULER3;
public var FILL5 = KULER2;
public var STROKE1 = KULER3;
public var STROKE2 = KULER3;
public var STROKE3 = KULER1;
public var STROKE4 = KULER2;
public var STROKE5 = KULER3;

public class BlackAndBlueStyle {
    
    public var APPLICATION_BACKGROUND_FILL = FILL1;
    
    public var APPLICATION_BACKGROUND_STROKE = STROKE1;
    
    // tweetsview styles
    public var TWEETSVIEW_TITLEBAR_FILL = FILL5;
    public var TWEETSVIEW_STROKE = FILL5;
    public var TWEETSVIEW_FILL = Color.TRANSPARENT;
    public var TWEETSVIEW_TITLEBAR_TEXT_FILL = STROKE5;
    public var TWEETSVIEW_TITLEBAR_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
        embolden: true
    }

    // title bar styles
    public var APPLICATION_TITLEBAR_FILL = FILL5;
    public var APPLICATION_TITLEBAR_TEXT_FILL = STROKE5;
    public var APPLICATION_TITLEBAR_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
        embolden: true
    }
    
    // status bar styles
    public var APPLICATION_STATUSBAR_FILL = FILL2;
    public var APPLICATION_STATUSBAR_TEXT_FILL = STROKE2;
    public var APPLICATION_STATUSBAR_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
        embolden: true
    }
    
    // update styles
    public var UPDATEBOX_FILL = FILL3;
    public var UPDATEBOX_STROKE = STROKE3;
    public var UPDATE_FILL = FILL4;
    public var UPDATEBOX_DMTO_TEXT_BG_FILL = FILL4;
    public var UPDATEBOX_DMTO_TEXT_FILL = STROKE4;
    public var UPDATE_TEXT_FILL = Color.WHITE;
    public var UPDATE_LINK_FILL = Color.BLUE;
    public var UPDATE_TEXT_FONT = Font {
        name: "Verdana"
        size: 10
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
        size: 20
    }

    // alert box styles
    public var ALERT_TEXT_FILL = FILL4;
    public var ALERT_TEXT_FONT = Font {
        name: "Verdana"
        size: 12
        embolden: true
    }

    // button styles
    public var BUTTON_STROKE = Style.buttonStrokeGradient(FILL3);
    public var BUTTON_FILL = Style.buttonFillGradient(FILL3);
    public var BUTTON_TEXT_FILL = STROKE3;
    public var BUTTON_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
    }

    // scroll bar styles
    public var SCROLLBAR_TRACK_FILL = FILL4;
    public var SCROLLBAR_THUMB_FILL = STROKE4;

    // tab navigator styles
    public var TAB_TEXT_FILL = BUTTON_TEXT_FILL;
    public var TAB_TEXT_FONT = BUTTON_TEXT_FONT;
    public var TAB_FILL = BUTTON_FILL;
    public var TAB_STROKE = BUTTON_STROKE;
    public var TABVIEW_STROKE = KULER2;

    // Dialog styles
    public var DIALOG_FILL = FILL1;
    public var DIALOG_STROKE = FILL1;
    public var DIALOG_TEXT_FILL = STROKE1;
    public var DIALOG_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
    }
    public var DIALOG_TITLEBAR_FILL = FILL5;
    public var DIALOG_TITLEBAR_TEXT_FILL = STROKE5;
    public var DIALOG_TITLEBAR_TEXT_FONT = Font {
        name: "Verdana"
        size: 11
        embolden: true
    };
    
}
