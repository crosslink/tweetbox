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
import tweetbox.ui.HTMLNode;
import tweetbox.control.FrontController;

import javafx.ext.swing.SwingComponent;
import javafx.ext.swing.SwingLabel;
import javax.swing.JLabel;

import javafx.scene.input.MouseEvent;
import javafx.animation.*;
import javafx.scene.effect.*;
import javafx.scene.transform.*;

import com.javafxpert.custom_node.ButtonNode;

/**
 * @author mnankman
 */
public class TweetNode extends CustomNode {

    public var tweet:TweetVO;
    var user:UserVO = bind tweet.user;
    public var height:Number;
    public var width:Number;
    
  /**
   * An image of a play button to be displayed in each row of the table
   */
    public var buddyImage = Image {url: "{__DIR__}images/buddy.png"};
    
    var nodeStyle = Style.getApplicationStyle();
   
  /**
   * The opacity of the text when not in a rollover state
   */
    public var buttonOpacityValue:Number = 0.0;

  /**
   * A Timeline to control fading behavior when mouse enters or exits a button
   */
    var fadeTimeline =
    Timeline {
        keyFrames: [
            KeyFrame {
                time: 400ms
                values: [buttonOpacityValue => 1.0 tween Interpolator.LINEAR]
            }
        ]
    };

    var mouseInside:Boolean;
    
    var controller = FrontController.getInstance();
    
    
    
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
                                    Image {
                                        backgroundLoading: true
                                        url: "{user.profileImageUrl}"
                                    }

                            onMouseEntered: function(me:MouseEvent):Void {
                                mouseInside = true;
                                fadeTimeline.rate = 1.0;
                                fadeTimeline.play();
                            }

                            onMouseExited: function(me:MouseEvent):Void {
                                mouseInside = false;
                                fadeTimeline.rate = -1.0;
                                fadeTimeline.play();
                                me.node.effect = null
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
                        },
                    ]
                };

            var tweetActionButtonGroup: Group = Group {
                    translateX: 5
                    translateY: 5
                    opacity: bind buttonOpacityValue
                    content: [
                        ImageView {
                            translateX: 5
                            translateY: 5
                            image: Image {
                                url: "{__DIR__}icons/reply.png"
                            }
                            onMouseClicked:
                            function(me:MouseEvent):Void {
                                controller.reply(user.screenName);
                            }
                        },
                        ImageView {
                            translateX: 25
                            translateY: 5
                            image: Image {
                                url: "{__DIR__}icons/email.png"
                            }
                            onMouseClicked:
                            function(me:MouseEvent):Void {
                                controller.direct(user.screenName);
                            }
                        },
                        ImageView {
                            translateX: 5
                            translateY: 25
                            image: Image {
                                url: "{__DIR__}icons/follow.png"
                            }
                            onMouseClicked:
                            function(me:MouseEvent):Void {
                                controller.follow(user.screenName);
                            }
                        },
                        ImageView {
                            translateX: 25
                            translateY: 25
                            image: Image {
                                url: "{__DIR__}icons/control_fastforward.png"
                            }
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

