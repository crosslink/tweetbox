/*
 * TwitterAPISettings.fx
 *
 * Created on 8-nov-2008, 22:42:58
 */

package tweetbox.valueobject;

import javafx.lang.Duration;
/**
 * @author mnankman
 */

public class TwitterAPISettingsVO {
    public var getFriendTimelineInterval:Duration;
    public var getUserTimelineInterval:Duration;
    public var getRepliesInterval:Duration;
    public var getDirectMessagesInterval:Duration;
}
