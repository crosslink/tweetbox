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

public class Theme {

    public var NAME:String;
    
    public var APPLICATION_BACKGROUND_FILL:Paint;
    public var APPLICATION_BACKGROUND_STROKE:Paint;
    
    // tweetsview styles
    public var TWEETSVIEW_TITLEBAR_FILL:Paint;
    public var TWEETSVIEW_STROKE:Paint;
    public var TWEETSVIEW_FILL:Paint;
    public var TWEETSVIEW_TITLEBAR_TEXT_FILL:Paint;
    public var TWEETSVIEW_TITLEBAR_TEXT_FONT:Font;

    // title bar styles
    public var APPLICATION_TITLEBAR_FILL:Paint;
    public var APPLICATION_TITLEBAR_TEXT_FILL:Paint;
    public var APPLICATION_TITLEBAR_TEXT_FONT:Font;
    
    // status bar styles
    public var APPLICATION_STATUSBAR_FILL:Paint;
    public var APPLICATION_STATUSBAR_TEXT_FILL:Paint;
    public var APPLICATION_STATUSBAR_TEXT_FONT:Font;
    
    // update styles
    public var UPDATEBOX_FILL:Paint;
    public var UPDATEBOX_STROKE:Paint;
    public var UPDATE_FILL:Paint;
    public var UPDATEBOX_DMTO_TEXT_BG_FILL:Paint;
    public var UPDATEBOX_DMTO_TEXT_FILL:Paint;
    public var UPDATE_TEXT_FILL:Paint;
    public var UPDATE_LINK_FILL:Paint;
    public var UPDATE_TEXT_FONT:Font;
    public var UPDATECOUNTER_TEXT_FILL:Paint;
    public var UPDATECOUNTER_TOOMUCH_TEXT_FILL:Paint;
    public var UPDATECOUNTER_TEXT_FONT:Font;

    // group node styles
    public var GROUPNODE_TEXT_FILL:Paint;
    public var GROUPNODE_TEXT_FONT:Font;

    // alert box styles
    public var ALERT_TEXT_FILL:Paint;
    public var ALERT_TEXT_FONT:Font;

    // button styles
    public var BUTTON_STROKE:Paint;
    public var BUTTON_FILL:Paint;
    public var BUTTON_TEXT_FILL:Paint;
    public var BUTTON_TEXT_FONT:Font;

    // scroll bar styles
    public var SCROLLBAR_TRACK_FILL:Paint;
    public var VERTICALSCROLLBAR_THUMB_FILL:Paint;
    public var HORIZONTALSCROLLBAR_THUMB_FILL:Paint;

    // tab navigator styles
    public var TAB_TEXT_FILL:Paint;
    public var TAB_TEXT_FONT:Font;
    public var TAB_FILL:Paint;
    public var TAB_STROKE:Paint;
    public var TABVIEW_STROKE:Paint;

    // Dialog styles
    public var DIALOG_FILL:Paint;
    public var DIALOG_STROKE:Paint;
    public var DIALOG_TEXT_FILL:Paint;
    public var DIALOG_TEXT_FONT:Font;
    public var DIALOG_TITLEBAR_FILL:Paint;
    public var DIALOG_TITLEBAR_TEXT_FILL:Paint;
    public var DIALOG_TITLEBAR_TEXT_FONT = APPLICATION_STATUSBAR_TEXT_FONT;
    
    // error styles
    public var ERROR_FILL:Paint;
    public var ERROR_TEXT_FILL:Paint;
    public var ERROR_TEXT_FONT:Font;

}
