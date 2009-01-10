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
    public var status:Status;
    
    public var user:UserVO = UserVO {
        user: bind status.getUser()
    }
    
    public var text:String = bind status.getText();
    public var createdAt:Date = bind status.getCreatedAt();
    public var source:String = bind status.getSource();
    public var inReplyToId = bind status.getInReplyToUserId();
    
    public var isReply:Boolean = bind (status.getInReplyToUserId() != -1)
    
}
