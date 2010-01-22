/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package twitter4j;

import java.util.List;
import twitter4j.http.PostParameter;

/**
 * This class is an extension of class twitter4j.Twitter. It provides additional methods for retrieving 
 * objects (Statuses, DirectMessages, Users, et cetera) from the Twitter API.
 * 
 * This extension is defined in the twitter4j package to gain access to package protected methods
 *
 * @author mnankman
 */
public class MoreTwitter extends Twitter {
    private String baseURL = "http://twitter.com/";

    /**
     * Returns the count most recent statuses posted since the specified status (identified by sinceId) was posted
     *
     * @param sinceId returned statuses should be more recent than the status with this id
     * @count the maximum number of statuses to return
     * @return list of the Friends Timeline
     * @throws TwitterException when Twitter service or network is unavailable
     */
    public synchronized List<Status> getFriendsTimeline(int sinceId, int count) throws
            TwitterException {
        return Status.constructStatuses(
                this.get(baseURL + "statuses/friends_timeline.xml",
                new PostParameter[]{
                    new PostParameter("since_id", String.valueOf(sinceId)),
                    new PostParameter("count", String.valueOf(count))
                },
                true), this);
    }

    /**
     * Returns the count most recent replies posted since the specified status (identified by sinceId) was posted
     *
     * @param sinceId returned statuses should be more recent than the status with this id
     * @count the maximum number of statuses to return
     * @return list of Replies
     * @throws TwitterException when Twitter service or network is unavailable
     */
    public synchronized List<Status> getReplies(int sinceId, int count) throws
            TwitterException {
        return Status.constructStatuses(
                this.get(baseURL + "statuses/mentions.xml",
                new PostParameter[]{
                    new PostParameter("since_id", String.valueOf(sinceId)),
                    new PostParameter("count", String.valueOf(count))
                },
                true), this);
    }
}
