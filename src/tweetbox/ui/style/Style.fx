/*
 * Style.fx
 *
 * Created on 7-nov-2008, 10:11:12
 */

package tweetbox.ui.style;

import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import java.lang.Math;

import tweetbox.model.Model;
/**
 * @author mnankman
 */

var themeName = bind Model.getInstance().config.themeName on replace {
    println("themeName = {themeName}");
}

var themes:Theme[] = Model.getInstance().themes;

public bound function getApplicationStyle() {
    var result:Theme[] = for (t:Theme in themes) if (t.NAME == themeName) t else null;
    return if (sizeof result>0) result[0] else themes[0];
}

/**
 * adjusts the brightness of the provided color by the provided adjustment and returns the resulting color
 * @param c - the Color instance to be adjusted
 * @param adjustment - a number representing the relative brightness adjustment,
 *                     e.g. 2.0 would double c's brightness, 0.5 would split it in half
 */
public function adjustBrightness(c:Color, adjustment:Number): Color {
    return Color {
        red: Math.min(1.0, Math.round(c.red * adjustment))
        green: Math.min(1.0, Math.round(c.green * adjustment))
        blue: Math.min(1.0, Math.round(c.blue * adjustment))
    }
}

/**
 * adjusts the opacity of the provided color and returns the resulting color
 * @param c - the Color instance to be adjusted
 * @param opacity - the required opacity of the color
 */
public function adjustOpacity(c:Color, opacity:Number): Color {
    return Color {
        red: c.red
        green: c.green
        blue: c.blue
        opacity: opacity
    }
}

/**
 * creates a linear gradient for the fill of a button
 * @param baseColor - the base color
 */
public function buttonFillGradient(baseColor:Color): LinearGradient {
   return LinearGradient {
        startX: 0 startY: 0
        endX: 0 endY: 1
        stops: [
            Stop { offset: 0.0 color: baseColor },
            Stop { offset: 0.9 color: adjustBrightness(baseColor, 0.95) },
            Stop { offset: 1.0 color: adjustBrightness(baseColor, 0.8) },
        ]
    };
}

/**
 * creates a linear gradient for the stroke of a button
 * @param baseColor - the base color
 */
public function buttonStrokeGradient(baseColor:Color): LinearGradient {
   return LinearGradient {
        startX: 0 startY: 0
        endX: 0 endY: 1
        stops: [
            Stop { offset: 0.0 color: adjustBrightness(baseColor, 0.8) },
            Stop { offset: 1.0 color: baseColor },
        ]
    };
}

/**
 * creates a linear gradient for the fill of a scrollbar thumb
 * @param baseColor - the base color
 * @param orientation - 0 = horizontal, 1 = vertical
 */
public function scrollbarThumbFillGradient(baseColor:Color, orientation:Integer): LinearGradient {
   var endY:Number = if (orientation == 0) 1 else 0;
   return LinearGradient {
        startX: 0 startY: 0
        endX: 1-endY endY: endY
        stops: [
            Stop { offset: 0.0 color: baseColor },
            Stop { offset: 0.9 color: adjustBrightness(baseColor, 0.95) },
            Stop { offset: 1.0 color: adjustBrightness(baseColor, 0.8) },
        ]
    };
}

/**
 * creates a linear gradient for the stroke of a scrollbar thumb
 * @param baseColor - the base color
 * @param orientation - 0 = horizontal, 1 = vertical
 */
public function scrollbarThumbStrokeGradient(baseColor:Color, orientation:Integer): LinearGradient {
   var endY:Number = if (orientation == 0) 1 else 0;
   return LinearGradient {
        startX: 0 startY: 0
        endX: 1 endY: 0
        stops: [
            Stop { offset: 0.0 color: adjustBrightness(baseColor, 0.8) },
            Stop { offset: 1.0 color: baseColor },
        ]
    };
}
