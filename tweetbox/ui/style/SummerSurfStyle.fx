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

public var KULER_BASE:Color = Color.rgb(127,51,25);
public var KULER2:Color = Color.rgb(92,229,207);
public var KULER3:Color = Color.rgb(153,153,107);
public var KULER4:Color = Color.rgb(153,107,31);
public var KULER5:Color = Color.rgb(255,127,0);

public class SummerSurfStyle {
    
    public var APPLICATION_BACKGROUND_FILL: Paint = KULER_BASE;
    
    public var APPLICATION_BACKGROUND_STROKE: Paint = KULER5;
    
    // scroll bar styles
    public var SCROLLBAR_TRACK_FILL: Paint = KULER3;
    public var SCROLLBAR_THUMB_FILL: Paint = KULER5;

    // title bar styles
    public var APPLICATION_TITLEBAR_FILL: Paint = KULER2;
    public var APPLICATION_TITLEBAR_TEXT_FILL: Paint = KULER5;
    public var APPLICATION_TITLEBAR_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
        embolden: true
    }
    
    // status bar styles
    public var APPLICATION_STATUSBAR_FILL: Paint = KULER_BASE;
    public var APPLICATION_STATUSBAR_TEXT_FILL: Paint = KULER5;
    public var APPLICATION_STATUSBAR_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
        embolden: true
    }
    
    // update styles
    public var UPDATE_FILL: Paint = KULER4;
    public var REPLY_FILL: Paint = KULER4;
    public var DIRECTMESSAGE_FILL: Paint = KULER4;
    public var MYUPDATE_FILL: Paint = KULER4;
    public var UPDATE_TEXT_FILL: Paint = KULER5;
    public var UPDATE_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
    }

    // group button styles
    public var GROUPBUTTON_BORDER_COLOR: Paint = KULER2;
    public var GROUPBUTTON_HOVER_FILL: Paint = KULER3;
    public var GROUPBUTTON_SELECTED_FILL: Paint = KULER3;
    public var GROUPBUTTON_TEXT_FILL: Paint = KULER5;
    public var GROUPBUTTON_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
    }
    
}
