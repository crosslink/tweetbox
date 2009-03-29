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
import twitter4j.TwitterResponse;
import twitter4j.User;

import javax.swing.text.Document;

/**
 * @author mnankman
 */

public class TweetVO {
    public var response:TwitterResponse;

    var status:Status = if (response instanceof Status) response as Status else null;
    var dm:DirectMessage  = if (response instanceof DirectMessage) response as DirectMessage else null;

    public var id =
        if (status != null) status.getId()
        else if (dm != null) dm.getId()
        else -1;

    public var user:UserVO = UserVO {
        user: bind
            if (status != null)
                status.getUser()
            else if (dm != null)
                dm.getSender()
            else if (response instanceof User) response as User 
            else null;
    }

    public var text:String = bind
        if (status != null)
            status.getText()
        else if (dm != null)
            dm.getText()
        else if (response instanceof User) "{user.description}, {user.followersCount} followers, location: {user.location}"
        else null;

    public var html: String = null;

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
