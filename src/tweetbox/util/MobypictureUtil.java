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
public class MobypictureUtil {
    public static final String MOBYPICTURE_API = "http://api.mobypicture.com";
    public static final String MOBYPICTURE = "http://mobypicture.com";

    public static String getThumbUrl(String picId) {
        if (picId == null || picId.trim().length() == 0) return null;
        return MOBYPICTURE_API + "?t={MOBYPICTURE}/?{picId}&action=getThumbUrl&s=small&k=aaaaaaa&format=plain";
    }

    public static String extractPicId(String url) {
        if (url.startsWith(MOBYPICTURE)) {
            return url.substring(MOBYPICTURE.length()+1);
        }
        else {
            return null;
        }
    }

}
