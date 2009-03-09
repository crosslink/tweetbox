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
import tweetbox.generic.component.Link;
import tweetbox.generic.component.Icon;
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

    public var user:UserVO = tweet.user;

    var nodeStyle = Style.getApplicationStyle();

    protected var tweetContent: Node[] = [];
    var tcCurrentRow:Number = 0;
    var tcX:Number = 0;
    var tcY:Number = 0;
    var tcRowHeight:Number = 0;

    protected function linkClicked(url:String) {
        println("link: {url} clicked");
        BrowserLauncher.openURL(url.trim());
    }

    protected function addToTweetContent(node:Node) {
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

        node.translateX = node.translateX + tcX;
        node.translateY = node.translateY + tcY;

        // update the height of the current row
        if (h > tcRowHeight) tcRowHeight = h;

        tcX += w;
        insert node into tweetContent;
    }

    protected function createTextNode(content:String): Void {
        addToTweetContent(Text {
            translateY: nodeStyle.UPDATE_TEXT_FONT.size
            content: content
            fill: nodeStyle.UPDATE_TEXT_FILL
            font: nodeStyle.UPDATE_TEXT_FONT
        });
    }

    protected function createLinkNode(content:String, url:String): Void {
        addToTweetContent(Link {
            label: content
            url: url
        });
    }

    protected function createLinkIcon(url:String): Void {
        addToTweetContent(Icon {
            imageURL: "{__DIR__}icons/link.png"
            label: "url"
            translateY:-20
            action: function() {
                linkClicked(url);
            }
        });
    }

    protected function createTextNodes(content:String): Void {
        var tokens:String[] = content.split("\\s");
        for (t:String in tokens) {
            if (t.startsWith("http") or t.startsWith("ftp"))
                createLinkNode("link", t)
            else if (t.startsWith("@"))
                createLinkNode(t, "http://twitter.com/{t.substring(1)}")
            else if (t.startsWith("#"))
                createLinkNode(t, "http://www.hashtags.org/tag/{t.substring(1)}")
            else
                createTextNode(t)
        }
    }

    function createTweetContent(): Node[] {
        tweetContent = [];
        createLinkNode("{user.screenName}", "http://twitter.com/{user.screenName}");
        createTextNode(": ");
        if (tweet.text != null) createTextNodes(tweet.text);
        if (tweet.createdAt != null) createTextNodes("{DateUtil.formatAsTweetDisplayDate(tweet.createdAt)} with ");
        addToTweetContent(HTMLNode {html: tweet.source font: nodeStyle.UPDATE_TEXT_FONT onLinkClicked:linkClicked});
        return tweetContent;
    }


    public override function create(): Node {
        return Group {
            cache:true
            content: createTweetContent()
        };
    }
}