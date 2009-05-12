/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tweetbox.twitter;

import java.io.Serializable;
import java.util.Map;
import java.util.HashMap;
import twitter4j.User;

/**
 *
 * @author mnankman
 */
public class UserMap implements Serializable {
    private Map<Long, User> users;

    public UserMap() {
        this.users = new HashMap<Long, User>();
    }

    public UserMap(Map<Long, User> users) {
        this.users = new HashMap<Long, User>(users);
    }

    public boolean containsUser(int id) {
        return users.containsKey(new Long(id));
    }

    public boolean containsUser(User user) {
        return users.containsKey(new Long(user.getId()));
    }

    public User getUser(int id) {
        //System.out.println(this.getClass().getName()+".getUser(" + id + ")");
        return (User)users.get(new Long(id));
    }

    public void addUser(User user) {
        if (!containsUser(user)) {
            //System.out.println(this.getClass().getName()+".addUser(" + user + ")");
            users.put(new Long(user.getId()), user);
        }
    }

}
