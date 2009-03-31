/*
 * SimpleCellRenderer.fx
 *
 * Created on 3-mrt-2009, 12:54:24
 */

package tweetbox.ui;

import javafx.scene.Node;
import javafx.scene.text.Text;
import javafx.scene.Group;
import javafx.scene.shape.Rectangle;
import javafx.geometry.Rectangle2D;
import javafx.scene.paint.Color;
import tweetbox.generic.component.listboxcellrenderer.ListBoxCellRenderer;
import tweetbox.valueobject.TweetVO;
import twitter4j.TwitterResponse;

/**
 * @author mnankman
 */

public class TweetCellRenderer extends ListBoxCellRenderer {
    public override function create(data:Object, bounds:Rectangle2D) {
        var tn:TweetNode = data as TweetNode;
        tn.width = bounds.width;
        tn.height = bounds.height;
        return tn;
//        return TweetNode {
//            width: bounds.width
//            height: bounds.height
//            tweet: data as TweetVO
//        }

    }
}
