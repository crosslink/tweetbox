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
    public var user:User;
    
    public var screenName:String = bind user.getScreenName() as String;
    public var description:String = bind user.getDescription() as String;
    public var followersCount = bind user.getFollowersCount();
    public var location:String = bind user.getLocation();
    public var profileImageUrl:String = bind user.getProfileImageURL().toString();
}
