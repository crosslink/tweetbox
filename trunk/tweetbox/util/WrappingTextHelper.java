/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tweetbox.util;

import java.util.List;
import java.util.Vector;
import java.awt.font.TextMeasurer;
import java.awt.font.FontRenderContext;
import java.awt.Font;
import javax.swing.JComponent;
import javax.swing.JLabel;
import java.text.*;

/**
 *
 * @author mnankman
 */
public class WrappingTextHelper {
    private static JLabel dummyLabel; // needed for its FontMetrics
    
    static {
        dummyLabel = new JLabel();
    }
    
    public static List wrapText(String text, Font font, float maxAdvance) {
        List<String> result = new Vector<String>();
        
        //System.out.println("WrappingTextHelper.wrapText(" + text + "," + font + "," + component + "," + maxAdvance + ")");
        
        FontRenderContext frc = dummyLabel.getFontMetrics(font).getFontRenderContext();
        
        TextMeasurer tm = new TextMeasurer(new AttributedString(text).getIterator(), frc);
        int lbi = tm.getLineBreakIndex(0, maxAdvance);
        int start = 0;
        //int j = 0;
        while (start < lbi) {
            result.add(text.substring(start, lbi));
            start = lbi;
            lbi = tm.getLineBreakIndex(lbi, maxAdvance);
            //System.out.println("lbi = " + lbi + " : " + "'" + result.get(j) + "'");
            //j++;
        }
        return result;
    }
}
