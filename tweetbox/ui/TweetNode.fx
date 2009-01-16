/*
 * TweetNode.fx
 *
 * Created on 31-okt-2008, 10:51:40
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.text.*;
import javafx.scene.image.*;
import javafx.scene.effect.*;
import javafx.scene.layout.*;
import javafx.scene.shape.*;
import javafx.scene.paint.*;
import javafx.scene.*;

import tweetbox.model.*;
import tweetbox.valueobject.TweetVO;
import tweetbox.valueobject.UserVO;
import tweetbox.util.DateUtil;
import tweetbox.util.HtmlUtil;
import tweetbox.ui.style.Style;
import tweetbox.generic.layout.FlowBox;
import tweetbox.generic.component.HTMLNode;
import tweetbox.control.FrontController;
import tweetbox.generic.util.ImageCache;

import javafx.ext.swing.SwingComponent;
import javafx.ext.swing.SwingLabel;
import javax.swing.JLabel;

import javafx.scene.input.MouseEvent;
import javafx.animation.*;
import javafx.scene.effect.*;
import javafx.scene.transform.*;
import javafx.scene.Cursor;
import javafx.scene.paint.Color;

def replyIcon = Image {url: "{__DIR__}icons/reply.png"};
def dmIcon = Image {url: "{__DIR__}icons/email.png"};
def followIcon = Image {url: "{__DIR__}icons/follow.png"};
def rtIcon = Image {url: "{__DIR__}icons/control_fastforward.png"};
def buddyImage = Image {url: "{__DIR__}images/buddy.png"};


/**
 * @author mnankman
 */
public class TweetNode extends CustomNode {

    public var tweet:TweetVO;
    var user:UserVO = bind tweet.user;
    public var height:Number;
    public var width:Number;

    var tweetContentWidth:Number = width - 150;
    
    var nodeStyle = Style.getApplicationStyle();
   
    var controller = FrontController.getInstance();
    var imageCache = ImageCache.getInstance();

    var tweetContent: Node[] = [];
    var tcCurrentRow:Number = 0;
    var tcX:Number = 0;
    var tcY:Number = 0;
    var tcRowHeight:Number = 0;

    function linkClicked(url:String) {
        println("link: {url} clicked")
    }

    function addToTweetContent(node:Node) {
        var w:Number = 0;
        var h:Number = 0;
        var bounds = node.layoutBounds;
        w = bounds.width;
        h = bounds.height;
        if (tcX+h >= tweetContentWidth) {
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

    function creatLinkNode(content:String): Void {
        addToTweetContent(Text {
            content: content
            font: nodeStyle.UPDATE_TEXT_FONT
            underline: true
            fill: Color.BLUE
            cursor: Cursor.HAND
            onMouseClicked: function(e:MouseEvent) {
                linkClicked(content);
            }
        });
    }

    function createTextNodes(content:String): Void {
        var tokens:String[] = content.split("\\s");
        for (t:String in tokens) {
            if (t.startsWith("http") or t.startsWith("ftp"))
                creatLinkNode(t)
            else
                createTextNode(t)
        }
    }

    function createTweetContent(): Node[] {
        tweetContent = [];
        createTextNode("{user.screenName}: ");
        createTextNodes(tweet.text);
        createTextNodes("{DateUtil.formatAsTweetDisplayDate(tweet.createdAt)} with ");
        addToTweetContent(HTMLNode {html: tweet.source font: nodeStyle.UPDATE_TEXT_FONT onLinkClicked:linkClicked});
        return tweetContent;
    }
    
    public override function create(): Node {
        var model = Model.getInstance();

        var profileImageUrl:String = bind user.profileImageUrl;
        var imageViewRef:ImageView;

        var tweetContentBox:HBox = HBox {
                translateY: 7
                //verticalAlignment: VerticalAlignment.TOP
                content: [

                    Group {
                        translateX: 5
                        content: [
                            Rectangle {
                                width: 50
                                height: 50
                                fill: Color.TRANSPARENT
                            },
                            // renders the profile image
                            // TODO: create generic component for this
                            imageViewRef = ImageView {
                                //translateX: 5
                                //translateY: 4

                                image: bind
                                    if (profileImageUrl == null)
                                        buddyImage
                                    else
                                        imageCache.getImage("{user.profileImageUrl}")

                                onMouseEntered: function(me:MouseEvent):Void {
                                    tweetActionButtonGroup.visible = true;
                                }

                                onMouseExited: function(me:MouseEvent):Void {
                                    tweetActionButtonGroup.visible = false;
                                }

                                clip: Rectangle {
                                    width: 50
                                    height: 50
                                }
                            }
                        ]
                    },

                    // renders the content of the tweet
                    // TODO: currently, the HTML node is noninteractive. Needs to become interactive of course.
                    /*
                    HTMLNode {
                        translateY: 5
                        translateX: 7
                        html: "<strong>{user.screenName}</strong>: {tweet.text} <br>{DateUtil.formatAsTweetDisplayDate(tweet.createdAt)} with {tweet.source}"
                        width: bind width - imageViewRef.layoutBounds.width - 100
                        height: 50
                        font: nodeStyle.UPDATE_TEXT_FONT
                    }
                    */
                    Group {
                        translateX: 7
                        translateY: 8
                        content: createTweetContent()
                    }
                ]
            };

        var tweetActionButtonGroup: Group = Group {
                translateX: 5
                translateY: 5
                visible: false
                //opacity: bind buttonOpacityValue
                content: [
                    ImageView {
                        translateX: 5
                        translateY: 5
                        image: bind replyIcon
                        onMouseClicked:
                        function(me:MouseEvent):Void {
                            controller.reply(user.screenName);
                        }
                    },
                    ImageView {
                        translateX: 25
                        translateY: 5
                        image: bind dmIcon
                        onMouseClicked:
                        function(me:MouseEvent):Void {
                            controller.direct(user.screenName);
                        }
                    },
                    ImageView {
                        translateX: 5
                        translateY: 25
                        image: bind followIcon
                        onMouseClicked:
                        function(me:MouseEvent):Void {
                            controller.follow(user.screenName);
                        }
                    },
                    ImageView {
                        translateX: 25
                        translateY: 25
                        image: bind rtIcon
                        onMouseClicked:
                        function(me:MouseEvent):Void {
                            controller.retweet(user.screenName, tweet.text);
                        }
                    },
                ]

            };
            
        return Group {
            content: bind [

                // invisible rectangle to consume height (and a bit extra to create a gap between tweets
                Rectangle {
                    height: 60
                    visible: false;
                },
                
                // the background of the tweet
                Rectangle {
                    translateY: 4
                    width: bind width - 20
                    height: bind tweetContentBox.layoutBounds.height + 4
                    arcWidth:10 
                    arcHeight:10
                    fill: nodeStyle.UPDATE_FILL
                },
                
                tweetContentBox,

                tweetActionButtonGroup
                
            ]
        };
    }
}

