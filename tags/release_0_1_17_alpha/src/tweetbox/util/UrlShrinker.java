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
public class UrlShrinker {

    public static String shrinkUrl(String service, String longUrl) {
        String request = service + "?url=" + longUrl;
        System.out.println("shrinkUrl(" + request + ")");
        try {
            URL url = new URL(request);
            URLConnection connection;
            connection = url.openConnection();
            connection.setDoInput(true);
            BufferedReader input = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            return input.readLine();
        } catch (IOException ex) {
            Logger.getLogger(UrlShrinker.class.getName()).log(Level.SEVERE, null, ex);
            return longUrl;
        }

    }

    public static String expandShortUrl(String shortUrl) {
        String request = shortUrl;
        System.out.println("expandShortUrl(" + request + ")");
        try {
            URL url = new URL(request);
            URLConnection connection;
            connection = url.openConnection();
            connection.setDoInput(true);
            BufferedReader input = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            return input.readLine();
        } catch (IOException ex) {
            Logger.getLogger(UrlShrinker.class.getName()).log(Level.SEVERE, null, ex);
            return shortUrl;
        }

    }
}
