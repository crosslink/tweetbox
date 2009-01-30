/*
 * TweetContentRenderer.fx
 *
 * Created on 17-jan-2009, 10:26:38
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.input.MouseEvent;
import javafx.scene.Cursor;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;

import tweetbox.generic.component.HTMLNode;
import tweetbox.util.DateUtil;
import tweetbox.ui.style.Style;
import tweetbox.valueobject.TweetVO;
import tweetbox.valueobject.UserVO;

import tweetbox.util.BrowserLauncher;

/**
 * @author mnankman
 */

public class TweetContentRenderer extends CustomNode {

    public var tweet:TweetVO;

    public var maxWidth:Number;

    var user:UserVO = tweet.user;

    var nodeStyle = Style.getApplicationStyle();

    var tweetContent: Node[] = [];
    var tcCurrentRow:Number = 0;
    var tcX:Number = 0;
    var tcY:Number = 0;
    var tcRowHeight:Number = 0;

    function linkClicked(url:String) {
        println("link: {url} clicked");
        BrowserLauncher.openURL(url);
    }

    function addToTweetContent(node:Node) {
        var w:Number = 0;
        var h:Number = 0;
        var bounds = node.layoutBounds;
        w = bounds.width;
        h = bounds.height;
        if (tcX+h >= maxWidth) {
            tcY += tcRowHeight;
            tcX = 0;
            tcRowHeight = 0;
        }

        node.translateX = tcX;
        node.translateY = tcY;

        // update the height of the current row
        if (h > tcRowHeight) tcRowHeight = h;

        tcX += w;
        insert node into tweetContent;
    }

    function createTextNode(content:String): Void {
        addToTweetContent(Text {
            content: content
            font: nodeStyle.UPDATE_TEXT_FONT
        });
    }

    function creatLinkNode(content:String, url:String): Void {
        addToTweetContent(Text {
            content: content
            font: nodeStyle.UPDATE_TEXT_FONT
            underline: true
            fill: Color.BLUE
            cursor: Cursor.HAND
            onMouseClicked: function(e:MouseEvent) {
                linkClicked(url);
            }
        });
    }

    function createTextNodes(content:String): Void {
        var tokens:String[] = content.split("\\s");
        for (t:String in tokens) {
            if (t.startsWith("http") or t.startsWith("ftp"))
                creatLinkNode(t, t)
            else if (t.startsWith("@"))
                creatLinkNode(t, "http://twitter.com/{t.substring(1)}")
            else if (t.startsWith("#"))
                creatLinkNode(t, "http://www.hashtags.org/tag/{t.substring(1)}")
            else
                createTextNode(t)
        }
    }

    function createTweetContent(): Node[] {
        tweetContent = [];
        createTextNode("{user.screenName}: ");
        if (tweet.text != null) createTextNodes(tweet.text);
        if (tweet.createdAt != null) createTextNodes("{DateUtil.formatAsTweetDisplayDate(tweet.createdAt)} with ");
        addToTweetContent(HTMLNode {html: tweet.source font: nodeStyle.UPDATE_TEXT_FONT onLinkClicked:linkClicked});
        return tweetContent;
    }


    public override function create(): Node {
        return Group {
            content: createTweetContent()
        };
    }
}