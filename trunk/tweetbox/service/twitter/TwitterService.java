/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package tweetbox.service.twitter;

import org.json.simple.*;
import java.net.*;
import java.io.*;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;
import java.util.Date;
import java.text.SimpleDateFormat;

/**
 *
 * @author mnankman
 */
public class TwitterService {
    
    private static final String twitterUrlPrefix =              "http://twitter.com";
    private static final String twitterPublicTimeLineJSONUrl =  twitterUrlPrefix + "/statuses/public_timeline.json";
    private static final String twitterFriendsTimeLineJSONUrl = twitterUrlPrefix + "/statuses/friends_timeline.json";
    private static final String twitterStatusUpdateUrl =        twitterUrlPrefix + "/statuses/update.json";
    
    private static final String twitterSearchUrlPrefix =        "http://search.twitter.com";
    private static final String twitterSearchJSONUrl =          twitterSearchUrlPrefix + "/search.json";
    
    private static TwitterService instance = null;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");
    
    public static TwitterService getInstance() {
        if (instance == null) {
            instance = new TwitterService();
        }
        return instance;
    }

    private TwitterService() {
    }

    public List getPublicTimeline() throws ServiceInvocationException {
        try {
            URL url = new URL(twitterPublicTimeLineJSONUrl);

            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
            String str;
            StringBuffer buf = new StringBuffer();
            while ((str = in.readLine()) != null) {
                buf.append(str);
            }

            in.close();

            Object obj = JSONValue.parse(buf.toString());
            
            JSONArray tweets = (JSONArray) obj;
            // DEBUG CODE
            dumpJSONArray(tweets);
            // END DEBUG CODE
            
            return tweets;
                    
  
        } catch (MalformedURLException e) {
            System.out.println(e);
            throw new ServiceInvocationException(e);
        } catch (IOException e) {
            System.out.println(e);
            throw new ServiceInvocationException(e);
        }
    }
    
    public List search(String query) throws ServiceInvocationException {
        try {
            URL url = new URL(twitterSearchJSONUrl + "?q=" + query.replace(" ", "+"));
            
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
            String str;
            StringBuffer buf = new StringBuffer();
            while ((str = in.readLine()) != null) {
                buf.append(str);
            }

            in.close();

            Object obj = JSONValue.parse(buf.toString());
            
            if (obj instanceof JSONObject) {
                JSONObject jo = (JSONObject) obj;
                if (jo.get("results") != null) {
                    JSONArray results = (JSONArray) jo.get("results");
                    return results;
                }
            }
            return null;
            
        } catch (MalformedURLException e) {
            System.out.println(e);
            throw new ServiceInvocationException(e);
        } catch (IOException e) {
            System.out.println(e);
            throw new ServiceInvocationException(e);
        }
    }

    public List getFriendsTimeline(final String login, final String password) throws ServiceInvocationException {
        return getFriendsTimeline(login, password, null);
    }
    
    public List getFriendsTimeline(final String login, final String password, final Date since) throws ServiceInvocationException {
        setDefaultAuthenticator(login, password);
        try {
            URL url = new URL(twitterFriendsTimeLineJSONUrl + (since==null ? "" : "?since="+dateFormat.format(since).replace(" ", "+")));
            System.out.println("getFriendsTimeline: url = " + url);
            
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
            String str;
            StringBuffer buf = new StringBuffer();
            while ((str = in.readLine()) != null) {
                buf.append(str);
            }

            in.close();

            Object obj = JSONValue.parse(buf.toString());
            
            JSONArray tweets = (JSONArray) obj;
            
            // DEBUG CODE
            //dumpJSONArray(tweets);
            // END DEBUG CODE
            List result = new Vector();
            result.addAll(tweets);
            return result;
        } catch (MalformedURLException e) {
            System.out.println(e);
            throw new ServiceInvocationException(e);
        } catch (IOException e) {
            System.out.println(e);
            throw new ServiceInvocationException(e);
        }
    }
    
    public void sendUpdate(final String login, final String password, final String update) throws ServiceInvocationException {
       System.out.println("sendUpdate('" + update + "')");                         
       setDefaultAuthenticator(login, password);
        try {
            String data = URLEncoder.encode("status", "UTF-8") + "=" + URLEncoder.encode("update", "UTF-8");
            URL url = new URL(twitterStatusUpdateUrl);
            
            URLConnection conn = url.openConnection();
            conn.setDoOutput(true);
            OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
            //wr.write(data);
            //wr.flush();

        } catch (MalformedURLException e) {
            System.out.println(e);
            throw new ServiceInvocationException(e);
        } catch (IOException e) {
            System.out.println(e);
            throw new ServiceInvocationException(e);
        }
    }
    

    private void setDefaultAuthenticator(final String login, final String password) {
        System.out.println("setDefaultAuthenticator(" + login + ")");
        Authenticator.setDefault(new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(login, password.toCharArray());
            }
        });
  
    }
    
    private void dumpJSONArray(JSONArray jsonArray) {
        Iterator it = jsonArray.iterator();
        while (it.hasNext()) {
            JSONObject o = (JSONObject)it.next();
            Iterator keyIt = o.keySet().iterator();
            System.out.println("\nJSONObject {");
            while (keyIt.hasNext()) {
                String key = (String)keyIt.next();
                System.out.println("  " + key + " = '" + o.get(key) + "'");
            }
            System.out.println("}");
        }
    }
}
