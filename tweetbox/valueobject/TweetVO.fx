/*
 * TweetVO.fx
 *
 * Created on 10-nov-2008, 23:14:40
 */

package tweetbox.valueobject;

import java.util.Date;
import tweetbox.util.DateUtil;
import twitter4j.Status;
import twitter4j.User;

/**
 * @author mnankman
 */

public class TweetVO {
    public attribute status:Status;
    
    public attribute user:UserVO = UserVO {
        user: bind status.getUser()
    }
    
    public attribute text:String = bind status.getText();
    public attribute createdAt:Date = bind status.getCreatedAt();
    public attribute source:String = bind status.getSource();
    
    
}
