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
    public static final String APIKEY = "tw3333tb00x";

    public static String getThumbUrl(String picId) {
        if (picId == null || picId.trim().length() == 0) return null;
        try {
            String encodedApiKey = java.net.URLEncoder.encode(APIKEY, "UTF-8");
            String request = MOBYPICTURE_API + "?t=" + picId
                    + "&action=getThumbUrl&s=small&k=" + encodedApiKey + "&format=plain";
            System.out.println("MobypictureUtil.getThumbUrl(" + request + ")");
            URL url = new URL(request);
            URLConnection connection;
            connection = url.openConnection();
            connection.setDoInput(true);
            BufferedReader input = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            return input.readLine();
        } catch (IOException ex) {
            Logger.getLogger(UrlShrinker.class.getName()).log(Level.SEVERE, null, ex);
            return picId;
        }

    }

    public static String extractPicId(String url) {
        if (url.startsWith(MOBYPICTURE)) {
            return url.substring(MOBYPICTURE.length()+2);
        }
        else {
            return null;
        }
    }

}
