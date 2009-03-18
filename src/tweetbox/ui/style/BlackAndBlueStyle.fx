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

public function create(): Theme {
    return Theme {
        NAME: "Black and Blue"

        APPLICATION_BACKGROUND_FILL : FILL1;
        APPLICATION_BACKGROUND_STROKE : STROKE1;

        // tweetsview styles
        TWEETSVIEW_TITLEBAR_FILL : FILL5;
        TWEETSVIEW_STROKE : FILL5;
        TWEETSVIEW_FILL : Color.TRANSPARENT;
        TWEETSVIEW_TITLEBAR_TEXT_FILL : STROKE5;
        TWEETSVIEW_TITLEBAR_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
            embolden: true
        }

        // title bar styles
        APPLICATION_TITLEBAR_FILL : FILL5;
        APPLICATION_TITLEBAR_TEXT_FILL : STROKE5;
        APPLICATION_TITLEBAR_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
            embolden: true
        }

        // status bar styles
        APPLICATION_STATUSBAR_FILL : FILL2;
        APPLICATION_STATUSBAR_TEXT_FILL : STROKE2;
        APPLICATION_STATUSBAR_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
            embolden: true
        }

        // update styles
        UPDATEBOX_FILL : FILL4;
        UPDATEBOX_STROKE : STROKE4;
        UPDATE_FILL : FILL4;
        UPDATEBOX_DMTO_TEXT_BG_FILL : FILL4;
        UPDATEBOX_DMTO_TEXT_FILL : STROKE4;
        UPDATE_TEXT_FILL : Color.BLACK;
        UPDATE_LINK_FILL : Color.BLUE;
        UPDATE_TEXT_FONT : Font {
            name: "Verdana"
            size: 10
        }
        UPDATECOUNTER_TEXT_FILL : Color.BLACK;
        UPDATECOUNTER_TOOMUCH_TEXT_FILL : Color.RED;
        UPDATECOUNTER_TEXT_FONT : Font {
            name: "Verdana"
            size: 20
        }

        // group node styles
        GROUPNODE_TEXT_FILL : Color.BLACK;
        GROUPNODE_TEXT_FONT : Font {
            name: "Verdana"
            size: 20
        }

        // alert box styles
        ALERT_TEXT_FILL : FILL4;
        ALERT_TEXT_FONT : Font {
            name: "Verdana"
            size: 12
            embolden: true
        }

        // button styles
        BUTTON_STROKE : Style.buttonStrokeGradient(FILL3);
        BUTTON_FILL : Style.buttonFillGradient(FILL3);
        BUTTON_TEXT_FILL : STROKE3;
        BUTTON_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
        }

        // scroll bar styles
        SCROLLBAR_TRACK_FILL : FILL5;
        VERTICALSCROLLBAR_THUMB_FILL : Style.scrollbarThumbFillGradient(FILL3, 1);
        HORIZONTALSCROLLBAR_THUMB_FILL : Style.scrollbarThumbFillGradient(FILL3, 0);

        // tab navigator styles
        TAB_TEXT_FILL : STROKE3;
        TAB_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
        };
        TAB_FILL : Style.buttonFillGradient(FILL3);
        TAB_STROKE : Style.buttonStrokeGradient(FILL3);
        TABVIEW_STROKE : KULER2;

        // Dialog styles
        DIALOG_FILL : FILL1;
        DIALOG_STROKE : FILL1;
        DIALOG_TEXT_FILL : STROKE1;
        DIALOG_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
        }
        DIALOG_TITLEBAR_FILL : FILL5;
        DIALOG_TITLEBAR_TEXT_FILL : STROKE5;
        DIALOG_TITLEBAR_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
            embolden: true
        };

        // error styles
        ERROR_FILL : FILL2;
        ERROR_TEXT_FILL : STROKE2;
        ERROR_TEXT_FONT : Font {
            name: "Verdana"
            size: 11
            embolden: true
        }

    }
}
