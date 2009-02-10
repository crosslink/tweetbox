/*
 * GetFriendsTimelineCommand.fx
 *
 * Created on 30-jan-2009, 13:19:26
 */

package tweetbox.command;

import java.util.Date;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterResponse;

import tweetbox.generic.command.AbstractCommand;
import tweetbox.valueobject.TwitterResponseVO;
import tweetbox.valueobject.GroupVO;

/**
 * @author mnankman
 */

public class GetDirectMessagesCommand extends AbstractCommand {
    public-init var twitter:Twitter;
    public-init var group:GroupVO;

    public override function execute() {
        println("GetDirectMessagesCommand.execute()");
        var result = twitter.getDirectMessages();
        return TwitterResponseVO {
            group:group
            result:result             
        }
    }


}
