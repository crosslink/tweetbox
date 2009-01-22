/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tweetbox.util;

/**
 *
 * @author mnankman
 */
public class HtmlUtil {
    private static final String URL_PATTERN = "^((ht|f)tp(s?)://|~/|/)?([w]+:w+@)?(([a-zA-Z]{1}([w-]+.?)*(.[w]{2,5})?)(:[d]{1,5})?)?((/?w+/)+|/?)(w+.w]{3,4})?([,]w+)*((?w+=w+)?(&w+=w+)*([,]w*)*)?";
    
    public static String wrapAllUrlsWithAnchorTag(String text) {
        return text.replaceAll(URL_PATTERN, "<a href=\"$1\">$1</a>");
    }

}
