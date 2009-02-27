/*
 * UserNodeContentRenderer.fx
 *
 * Created on 27-feb-2009, 13:33:54
 */

package tweetbox.ui;

import javafx.scene.Node;
import javafx.scene.Group;
import tweetbox.util.DateUtil;

/**
 * @author mnankman
 */

public class UserNodeContentRenderer extends TweetContentRenderer {
    override var tweetContent;

    function createUserContent(): Node[] {
        tweetContent = [];
        createLinkNode("{user.screenName}", "http://twitter.com/{user.screenName}");
        if (tweet.createdAt != null) createTextNodes("{DateUtil.formatAsTweetDisplayDate(tweet.createdAt)} with ");
        return tweetContent;
    }


    public override function create(): Node {
        return Group {
            cache:true
            content: createUserContent()
        };
    }

}
