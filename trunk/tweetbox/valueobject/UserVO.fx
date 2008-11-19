/*
 * UserVO.fx
 *
 * Created on 10-nov-2008, 23:23:02
 */

package tweetbox.valueobject;

import twitter4j.User;

/**
 * @author mnankman
 */

public class UserVO {
    public attribute user:User;
    
    public attribute screenName:String = bind user.getScreenName() as String;
    public attribute profileImageUrl:String = bind user.getProfileImageURL().toString();
}
