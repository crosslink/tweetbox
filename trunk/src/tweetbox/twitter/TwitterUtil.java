/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tweetbox.twitter;

import java.util.Set;
import java.util.List;
import java.util.Date;
import java.util.Calendar;

import java.util.TreeSet;
import twitter4j.TwitterResponse;
import twitter4j.Status;

/**
 *
 * @author mnankman
 */
public class TwitterUtil {

    public static Set<TwitterResponse> getNewUpdates(List<TwitterResponse> received, Set<TwitterResponse> target) {
        TwitterResponse update = null;
        if (received != null) {
            Set newUpdates = new TreeSet<TwitterResponse>();
            for (int i=0; i<received.size(); i++) {
                update = received.get(i);
                if (!target.contains(update)) {
                    newUpdates.add(update);
                }
            }
            return newUpdates;
        }
        return null;
    }

    public static Date getSinceDate(Set statuses) {
        Calendar cal = Calendar.getInstance();
        if (statuses != null && statuses.size() > 0) {
            Object[] statusArray = statuses.toArray();
            Status status = (Status)statusArray[0];
            cal.setTime(status.getCreatedAt());
        }
        else {
            cal.add(Calendar.HOUR_OF_DAY, -24);
        }
        return cal.getTime();
    }
}
