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
    public attribute getFriendTimelineInterval:Duration;
    public attribute getRepliesInterval:Duration;
    public attribute getDirectMessagesInterval:Duration;
}
