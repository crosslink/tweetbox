/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tweetbox.util;

import java.io.IOException;
import java.net.URL;
import java.net.URLConnection;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author mnankman
 */
public class TwitPicUtil {
    public static final String TWITPIC_SERVICE = "http://twitpic.com";

    public static String getThumbUrl(String picId) {
        if (picId == null || picId.trim().length() == 0) return null;
        return TWITPIC_SERVICE + "/show/thumb/" + picId;
    }

    public static String extractPicId(String url) {
        if (url.startsWith(TWITPIC_SERVICE)) {
            return url.substring(TWITPIC_SERVICE.length()+1);
        }
        else {
            return null;
        }
    }

}
