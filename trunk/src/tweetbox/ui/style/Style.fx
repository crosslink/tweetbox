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

/**
 * @author mnankman
 */

var APPLICATIONSTYLE = MeshStyle{}
//var APPLICATIONSTYLE = BlackAndBlueStyle{}

public function getApplicationStyle() {
    return APPLICATIONSTYLE;
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

public function buttonFillGradient(baseColor:Color): LinearGradient {
   return LinearGradient {
        startX: 0 startY: 0 endX: 0 endY: 1
        stops: [
            Stop { offset: 0.0 color: baseColor },
            Stop { offset: 0.9 color: adjustBrightness(baseColor, 0.95) },
            Stop { offset: 1.0 color: adjustBrightness(baseColor, 0.8) },
        ]
    };
}

public function buttonStrokeGradient(baseColor:Color): LinearGradient {
   return LinearGradient {
        startX: 0 startY: 0 endX: 0 endY: 1
        stops: [
            Stop { offset: 0.0 color: adjustBrightness(baseColor, 0.8) },
            Stop { offset: 1.0 color: baseColor },
        ]
    };
}

