/*
 * GetFriendsTimelineCommand.fx
 *
 * Created on 30-jan-2009, 13:19:26
 */

package tweetbox.command;

import java.util.Date;

import twitter4j.MoreTwitter;
import twitter4j.TwitterException;
import twitter4j.TwitterResponse;

import tweetbox.generic.command.AbstractCommand;
import tweetbox.valueobject.TwitterResponseVO;
import tweetbox.valueobject.GroupVO;

/**
 * @author mnankman
 */

public class GetRepliesCommand extends AbstractCommand {
    public-init var twitter:MoreTwitter;
    public-init var group:GroupVO;

    public override function execute() {
        println("GetRepliesCommand.execute()");
        //var result = twitter.getReplies();
        var result = if (group.mostRecentUpdateId != -1)
            twitter.getReplies(group.mostRecentUpdateId, group.maxVisibleUpdates)
        else
            twitter.getReplies();
        return TwitterResponseVO {
            group:group
            result:result             
        }
    }


}
