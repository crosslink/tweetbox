/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tweetbox.twitter;

import java.io.Serializable;
import java.util.Comparator;
import twitter4j.TwitterResponse;
import twitter4j.Status;
import twitter4j.DirectMessage;
import twitter4j.User;

/**
 *
 * @author mnankman
 */
public class TwitterResponseComparator implements Comparator, Serializable {

    @Override
    public int compare(Object o1, Object o2) throws ClassCastException {
        if (o2 instanceof TwitterResponse && o1.getClass() == o2.getClass()) {
           Long id1 = null;
           Long id2 = null;
           if (o1 instanceof Status) {
               id1 = new Long(((Status)o1).getId());
               id2 = new Long(((Status)o2).getId());
           }
           else if (o1 instanceof DirectMessage) {
               id1 = new Long(((DirectMessage)o1).getId());
               id2 = new Long(((DirectMessage)o2).getId());
           }
           else if (o1 instanceof User) {
               id1 = new Long(((User)o1).getId());
               id2 = new Long(((User)o2).getId());
           }
           if (id1 != null && id2 != null) {
               return id2.compareTo(id1);
           }
        }
        throw new ClassCastException("incomparable objects");
    }
}
