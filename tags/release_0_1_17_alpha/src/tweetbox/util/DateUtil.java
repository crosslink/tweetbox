/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tweetbox.util;

import java.text.ParseException;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author mnankman
 */
public class DateUtil {
    private final static SimpleDateFormat WEB_DATE_FORMAT = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss z");
    private final static SimpleDateFormat TWEET_CREATED_AT_DATE_FORMAT = new SimpleDateFormat("EEE MMM d HH:mm:ss Z yyyy");
    private final static SimpleDateFormat TWEET_DISPLAY_DATE_FORMAT = new SimpleDateFormat("d MMM yyyy HH:mm:ss");
    
    public static String formatAsWebDate(Date d) {
        return WEB_DATE_FORMAT.format(d);
    }
    
    public static Date parseFromTweetDateFormat(String webFormattedDate) {
        try {
            return TWEET_CREATED_AT_DATE_FORMAT.parse(webFormattedDate);
        } catch (ParseException ex) {
            Logger.getLogger(DateUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
        return new Date();
    }

    public static String formatAsTweetDisplayDate(Date d) {
        if (d != null) {
            return TWEET_DISPLAY_DATE_FORMAT.format(d);
        }
        else {
            return "";
        }
    }
    
}
