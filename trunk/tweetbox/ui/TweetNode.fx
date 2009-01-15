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
    
    var nodeStyle = Style.getApplicationStyle();
   
    var controller = FrontController.getInstance();
    var imageCache = ImageCache.getInstance();
    
    
    public override function create(): Node {
        return Group {
            var model = Model.getInstance();
            
            var profileImageUrl:String = bind user.profileImageUrl;
            var screenNameRef: Text;
            var statusRef: HTMLNode;
            var imageViewRef:ImageView;

            var tweetContentBox:HBox = HBox {
                    translateY: 2
                    //verticalAlignment: VerticalAlignment.TOP
                    content: [

                        // renders the profile image
                        // TODO: create generic component for this
                        imageViewRef = ImageView {
                            translateX: 5
                            translateY: 4

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
                        },

                        // renders the content of the tweet
                        // TODO: currently, the HTML node is noninteractive. Needs to become interactive of course.
                        HTMLNode {
                            translateY: 5
                            translateX: 7
                            html: "<strong>{user.screenName}</strong>: {tweet.text} <br>{DateUtil.formatAsTweetDisplayDate(tweet.createdAt)} with {tweet.source}"
                            width: bind width - imageViewRef.layoutBounds.width - 100
                            font: nodeStyle.UPDATE_TEXT_FONT
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

            content: bind [

                // invisible rectangle to consume height (and a bit extra to create a gap between tweets
                Rectangle {
                    height: bind tweetContentBox.layoutBounds.height + 5
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

