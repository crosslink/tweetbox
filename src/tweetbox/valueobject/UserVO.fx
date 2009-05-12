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
    
    public-read var screenName:String = bind user.getScreenName() as String;
    public-read var description:String = bind user.getDescription() as String;
    public-read var followersCount = bind user.getFollowersCount();
    public-read var location:String = bind user.getLocation();
    public-read var profileImageUrl:String = bind user.getProfileImageURL().toString();
}
