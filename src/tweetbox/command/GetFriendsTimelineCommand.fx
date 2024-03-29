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
import tweetbox.twitter.TwitterUtil;
/**
 * @author mnankman
 */

public class GetFriendsTimelineCommand extends AbstractCommand {
    public-init var twitter:MoreTwitter;
    public-init var group:GroupVO;

    var since:Date = TwitterUtil.getSinceDate(group.updates);

    public override function execute() {
        println("GetFriendsTimelineCommand.execute()");
        //var result = if (since != null) twitter.getFriendsTimeline(since) else twitter.getFriendsTimeline();
        var result = if (group.mostRecentUpdateId != -1)
            twitter.getFriendsTimeline(group.mostRecentUpdateId, group.maxVisibleUpdates)
        else
            twitter.getFriendsTimeline();
        since = new Date();
        return TwitterResponseVO {
            group:group
            result:result               
        }
    }


}
