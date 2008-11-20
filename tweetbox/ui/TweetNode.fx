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
import javafx.scene.geometry.*;
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

import javafx.ext.swing.Component;
import javafx.ext.swing.Label;
import javafx.ext.swing.ComponentView;
import javax.swing.JLabel;

import javafx.input.MouseEvent;
import javafx.animation.*;
import javafx.scene.effect.*;
import javafx.scene.transform.*;

import com.javafxpert.custom_node.ButtonNode;

/**
 * @author mnankman
 */
public class TweetNode extends CustomNode {

    public attribute tweet:TweetVO;
    private attribute user:UserVO = bind tweet.user;
    public attribute height:Integer;
    public attribute width:Integer;
    
  /**
   * An image of a play button to be displayed in each row of the table
   */
    public attribute buddyImage = Image {url: "{__DIR__}images/buddy.png"};
    
    private attribute style = Style.getApplicationStyle();
   
  /**
   * The opacity of the text when not in a rollover state
   */
    public attribute buttonOpacityValue:Number = 0.0;

  /**
   * A Timeline to control fading behavior when mouse enters or exits a button
   */
    private attribute fadeTimeline =
    Timeline {
        toggle: true
        keyFrames: [
            KeyFrame {
                time: 400ms
                values: [buttonOpacityValue => 1.0 tween Interpolator.LINEAR]
            }
        ]
    };

    private attribute mouseInside:Boolean;
    
    private attribute controller = FrontController.getInstance();
    
    public function create(): Node {
        return Group {
            var model = Model.getInstance();
            
            var profileImageUrl:String = bind user.profileImageUrl;
            var screenNameRef: Text;
            var statusRef: HTMLNode;
            var outerBoxRef: HBox;
            var imageViewRef:ImageView;
            
            content: bind [
                
                Rectangle {
                    translateY: 4
                    width: bind width - 2
                    height: bind outerBoxRef.getHeight() + 4
                    arcWidth:10 
                    arcHeight:10
                    fill: Color.WHITESMOKE
                    
                },
                outerBoxRef = HBox { 
                    translateY: 2
                    verticalAlignment: VerticalAlignment.TOP 
                    content: [
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

                            onMouseEntered:
                            function(me:MouseEvent):Void {
                                mouseInside = true;
                                fadeTimeline.start();
                            }

                            onMouseExited:
                            function(me:MouseEvent):Void {
                                mouseInside = false;
                                fadeTimeline.start();
                                me.node.effect = null
                            }
                        },
                        HTMLNode {
                            translateY: 5
                            translateX: 7
                            html: "<strong>{user.screenName}</strong>: {tweet.text} <br>{DateUtil.formatAsTweetDisplayDate(tweet.createdAt)} with {tweet.source}"
                            width: bind width - imageViewRef.getWidth() - 100
                            font: style.TWEET_TEXT_FONT
                        },
                    ]
                },
                Group {
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

                }
                
            ]
        };
    }
}

