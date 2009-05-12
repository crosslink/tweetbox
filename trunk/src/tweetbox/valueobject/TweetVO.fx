/*
 * TweetVO.fx
 *
 * Created on 10-nov-2008, 23:14:40
 */

package tweetbox.valueobject;

import java.util.Date;
import twitter4j.Status;
import twitter4j.DirectMessage;
import twitter4j.TwitterResponse;
import twitter4j.User;

import tweetbox.model.Model;


/**
 * @author mnankman
 */

public class TweetVO {
    public-init var response:TwitterResponse on replace {
        if (response instanceof Status) {
            status = response as Status;
            id = status.getId();
            user = UserVO{user: status.getUser()}
            text = status.getText();
            createdAt = status.getCreatedAt();
            source = status.getSource();
            inReplyToId = status.getInReplyToStatusId();
            inReplyToUserId = status.getInReplyToUserId();
            isReply = (inReplyToId != -1);
        }
        else if (response instanceof DirectMessage) {
            dm = response as DirectMessage;
            id = dm.getId();
            user = UserVO{user: dm.getSender()}
            text = dm.getText();
            createdAt = dm.getCreatedAt();
        }
        else if (response instanceof User) {
            user = UserVO{user: response as User}
            text = "{user.description}, {user.followersCount} followers, location: {user.location}"
        }

        if (user != null) {
            //remember this user

            //TODO: this value object shouldn't directly reference the Model instance.
            //      must be refactored into a looser coupling!!

            Model.getInstance().userMap.addUser(user.user);
        }

    }

    var status:Status = null;
    var dm:DirectMessage  = null;

    public-read var id = -1;
    public-read var user:UserVO = null;
    public-read var text:String = null;
    public-read var createdAt:Date = null;
    public-read var source:String = bind status.getSource();
    public-read var inReplyToId:Integer = -1;
    public-read var inReplyToUserId:Integer = -1;
    public-read var isReply:Boolean = false;

    public var html: String = null;

}
