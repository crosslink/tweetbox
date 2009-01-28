/*
 * TweetVO.fx
 *
 * Created on 10-nov-2008, 23:14:40
 */

package tweetbox.valueobject;

import java.util.Date;
import tweetbox.util.DateUtil;
import twitter4j.Status;
import twitter4j.DirectMessage;
import twitter4j.User;

/**
 * @author mnankman
 */

public class TweetVO {
    public var status:Status;
    public var dm:DirectMessage;

    public var user:UserVO = UserVO {
        user: bind
            if (status != null)
                status.getUser()
            else if (dm != null)
                dm.getSender()
            else null
    }

    public var text:String = bind
            if (status != null)
                status.getText()
            else if (dm != null)
                dm.getText()
            else null;

    public var createdAt:Date = bind
            if (status != null)
                status.getCreatedAt()
            else if (dm != null)
                dm.getCreatedAt()
            else null;

    public var source:String = bind status.getSource();

    public var inReplyToId = bind status.getInReplyToUserId();
    
    public var isReply:Boolean = bind (status.getInReplyToUserId() != -1)
    
}
