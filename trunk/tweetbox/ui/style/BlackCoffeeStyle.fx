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

public var BLACK_COFFEE:Color = Color.rgb(0, 0, 0);
public var LATTE:Color = Color.rgb(47,48,29);
public var CREAM:Color = Color.rgb(181,147,84);
public var BLUE:Color = Color.rgb(33,33,54);

public class BlackCoffeeStyle {
    public var APPLICATION_BACKGROUND_FILL: Paint = BLACK_COFFEE;
    
    public var APPLICATION_BACKGROUND_STROKE: Paint = LATTE;
    
    // scroll bar styles
    public var SCROLLBAR_TRACK_FILL: Paint = CREAM;
    public var SCROLLBAR_THUMB_FILL: Paint = LATTE;

    // title bar styles
    public var APPLICATION_TITLEBAR_FILL: Paint = LATTE;
    public var APPLICATION_TITLEBAR_TEXT_FILL: Paint = Color.WHITE;
    public var APPLICATION_TITLEBAR_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
        embolden: true
    }
    
    // status bar styles
    public var APPLICATION_STATUSBAR_FILL: Paint = BLACK_COFFEE;
    public var APPLICATION_STATUSBAR_TEXT_FILL: Paint = CREAM;
    public var APPLICATION_STATUSBAR_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
        embolden: true
    }
    
    // update styles
    public var UPDATE_FILL: Paint = BLUE;
    public var REPLY_FILL: Paint = BLUE;
    public var DIRECTMESSAGE_FILL: Paint = BLUE;
    public var MYUPDATE_FILL: Paint = BLUE;
    public var UPDATE_TEXT_FILL: Paint = Color.WHITE;
    public var UPDATE_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
    }

    // group button styles
    public var GROUPBUTTON_BORDER_COLOR: Paint = CREAM;
    public var GROUPBUTTON_HOVER_FILL: Paint = LATTE;
    public var GROUPBUTTON_SELECTED_FILL: Paint = LATTE;
    public var GROUPBUTTON_TEXT_FILL: Paint = Color.WHITE;
    public var GROUPBUTTON_TEXT_FONT: Font = Font {
        name: "Sans serif"
        size: 11
    }
    
}
