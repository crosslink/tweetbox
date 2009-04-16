/*
 * TweetContentRenderer.fx
 *
 * Created on 17-jan-2009, 10:26:38
 */

package tweetbox.ui;

import java.lang.Math;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.input.MouseEvent;
import javafx.scene.Cursor;
import javafx.scene.paint.Paint;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;
import javafx.scene.text.Font;
import javafx.geometry.Point2D;
import javafx.scene.image.*;
import javafx.scene.shape.Rectangle;

import tweetbox.generic.component.HTMLNode;
import tweetbox.generic.component.HTMLPane;
import tweetbox.generic.component.Link;
import tweetbox.generic.component.Icon;
import tweetbox.util.DateUtil;
import tweetbox.ui.style.Style;
import tweetbox.valueobject.TweetVO;
import tweetbox.valueobject.UserVO;

import tweetbox.util.BrowserLauncher;
import tweetbox.util.TwitPicUtil;
import tweetbox.util.MobypictureUtil;
import tweetbox.generic.util.ImageCache;

/**
 * @author mnankman
 */

public class TweetContentRenderer extends CustomNode {

    public var tweet:TweetVO;

    public var maxWidth:Number;
    public var maxHeight:Number;

    public var user:UserVO = tweet.user;

    var nodeStyle = bind Style.getApplicationStyle() on replace {
        if (nodeStyle != null) rerender();
    }
    var updateTextFont = bind nodeStyle.UPDATE_TEXT_FONT;
    var updateTextColor = bind nodeStyle.UPDATE_TEXT_FILL as Color;
    var linkColor = bind nodeStyle.UPDATE_LINK_FILL as Color;

    protected var tweetContent: Node[] = [];
    var tcCurrentRow:Number = 0;
    var tcX:Number = 0;
    var tcY:Number = 0;
    var tcRowHeight:Number = 0;

    var renderedNode:Node;

    protected function linkClicked(url:String) {
        BrowserLauncher.openURL(url.trim());
        Main.hideBalloon();
    }

    protected function linkEntered(url:String, point:Point2D):Void {
        var imageUrl:String = null;
        var picId:String = null;

        if (url.startsWith(TwitPicUtil.TWITPIC_SERVICE)) {
            picId = TwitPicUtil.extractPicId(url);
            imageUrl = TwitPicUtil.getThumbUrl(picId);
        }
        else if (url.startsWith(MobypictureUtil.MOBYPICTURE)) {
            picId = MobypictureUtil.extractPicId(url);
            imageUrl = MobypictureUtil.getThumbUrl(picId);
        }

        var balloonContent:Node =
            if (imageUrl != null)
                Group {
                    content: [
                        Rectangle {
                            fill: Color.TRANSPARENT;
                            width: 200
                            height: 200
                        },
                        Text {
                            translateY:80
                            translateX: 10
                            wrappingWidth: 180
                            textAlignment: TextAlignment.CENTER
                            content: "loading twitpic thumbnail for picture {picId}"
                        },
                        ImageView {
                            fitHeight:200
                            fitWidth:200
                            image: ImageCache.getInstance().getImage(imageUrl)
                        }
                    ]
                }

            else
                Text {
                    translateY:10
                    content:url
                }


        Main.showBalloon(point.x, point.y, balloonContent);
    }

    protected function linkExited(url:String, point:Point2D):Void {
        Main.hideBalloon();
    }

    protected function addToTweetContent(node:Node) {
        var w:Number = 0;
        var h:Number = 0;
        def bounds = node.layoutBounds;
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
            translateY: updateTextFont.size
            content: content
            fill: bind nodeStyle.UPDATE_TEXT_FILL
            font: bind updateTextFont
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
        addToTweetContent(HTMLNode {html: tweet.source font: bind nodeStyle.UPDATE_TEXT_FONT onLinkClicked:linkClicked});
        return tweetContent;
    }


    function createLinkHtml(content:String, url:String): String {
        return setStyle("<a href=\"{url}\">{content}</a>", updateTextFont, linkColor);
    }

    function setStyle(html:String, font:Font, color:Color):String {
        def rgbhex = java.lang.Integer.toHexString(color.getAWTColor().getRGB());
        def colorHtml = if (rgbhex != null and rgbhex.length() == 8) "#{rgbhex.substring(2)}" else "#000000";
        def fontSize:Integer = Math.round(font.size);
        return "<font name=\"{font.name}\" size=\"{font.size}\" color=\"{colorHtml}\">{html}</font>";
    }

    protected function createTextHtml(content:String): String {
        def tokens:String[] = content.split("\\s");
        var result:String = "";
        for (t:String in tokens) {
            if (t.startsWith("http") or t.startsWith("ftp"))
                if (t.contains(TwitPicUtil.TWITPIC_SERVICE) or t.contains(MobypictureUtil.MOBYPICTURE))
                    result = "{result}{createLinkHtml("picture", t)} "
                else
                    result = "{result}{createLinkHtml("link", t)} "
            else if (t.startsWith("@"))
                result = "{result}{createLinkHtml(t, "http://twitter.com/{t.substring(1)}")} "
            else if (t.startsWith("#"))
                result = "{result}{createLinkHtml(t, "http://www.hashtags.org/tag/{t.substring(1)}")} "
            else {
                result = "{result}{t} "
            }
        }
        return result.trim();
    }

    function createTweetHtml() {
        def sender = createLinkHtml("{user.screenName}", "http://twitter.com/{user.screenName}");
        def content = if (tweet.text == null) "" else createTextHtml(tweet.text);
        def createdAt = DateUtil.formatAsTweetDisplayDate(tweet.createdAt);
        def source = setStyle(tweet.source, updateTextFont, linkColor);
        tweet.html = setStyle("{sender}: {content}\n{createdAt} with {source}", , updateTextFont, updateTextColor);
    }

    function createHtmlPane(): Node {
        if (tweet.html == null) createTweetHtml();

        return HTMLPane {
            width: maxWidth
            height: maxHeight
            font: bind updateTextFont
            html: bind tweet.html
            onLinkClicked: linkClicked
            onLinkEntered: linkEntered
            onLinkExited: linkExited
        }
    }

    public function rerender() {
        createTweetHtml();
    }

    public override function create(): Node {
        renderedNode = createHtmlPane();
        rerender();
        return Group {
            cache:true
            content: bind renderedNode
        };
    }
}