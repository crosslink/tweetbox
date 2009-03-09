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
import tweetbox.ui.style.Style;
import tweetbox.control.FrontController;
import tweetbox.generic.util.ImageCache;

import javafx.scene.input.MouseEvent;
import javafx.scene.Cursor;
import javafx.scene.paint.Color;
import javafx.geometry.Point2D;

def replyIcon = Image {url: "{__DIR__}icons/comment.png"};
def dmIcon = Image {url: "{__DIR__}icons/email.png"};
def addFavIcon = Image {url: "{__DIR__}icons/heart_add.png"};
def delFavIcon = Image {url: "{__DIR__}icons/heart_delete.png"};
def rtIcon = Image {url: "{__DIR__}icons/control_fastforward.png"};
def buddyImage = Image {url: "{__DIR__}images/buddy.png"};
def placeholderImage = Image {url: "{__DIR__}images/piph.png"};

/**
 * @author mnankman
 */
public class UserNode extends CustomNode {

    public var height:Number;
    public var width:Number;
    public var user:UserVO;

    public var scale:Number=1.0;

    public var tweet:TweetVO; // this is the context of this user node is associated with. can be null.

    var replyIconVisible:Boolean = true;
    var rtIconVisible:Boolean = tweet != null;
    var addFavIconVisible:Boolean = tweet != null;
    var dmIconVisible:Boolean = true;

    var nodeStyle = Style.getApplicationStyle();
   
    var controller = FrontController.getInstance();
    var imageCache = ImageCache.getInstance();

    var model = Model.getInstance();

    var profileImageUrl:String = user.profileImageUrl;
    var imageViewRef:ImageView;



    var imageView:Node = ImageView {
        fitHeight: 50*scale
        fitWidth: 50*scale
        image:
            if (profileImageUrl == null)
                buddyImage
            else
                imageCache.getImage("{user.profileImageUrl}", placeholderImage)

        onMouseEntered: function(me:MouseEvent):Void {
            tweetActionButtonGroup.visible = true;
        }

        onMouseExited: function(me:MouseEvent):Void {
            tweetActionButtonGroup.visible = false;
        }
    };

    var tweetActionButtonGroup: Group = Group {
        scaleX: scale
        scaleY: scale
        translateX: 0
        translateY: 0
        visible: false
        //opacity: bind buttonOpacityValue
        content: [
            ImageView {
                visible: bind replyIconVisible
                translateX: 5
                translateY: 5
                image: bind replyIcon
                onMouseClicked: function(me:MouseEvent):Void {
                    controller.reply(
                        user,
                        Point2D{
                            x: imageView.boundsInScene.minX
                            y: imageView.boundsInScene.minY+imageView.boundsInLocal.height
                        });
                }
            },
            ImageView {
                visible: bind dmIconVisible
                translateX: 25
                translateY: 5
                image: bind dmIcon
                onMouseClicked: function(me:MouseEvent):Void {
                    controller.direct(
                        user,
                        Point2D{
                            x: imageView.boundsInScene.minX
                            y: imageView.boundsInScene.minY+imageView.boundsInLocal.height
                        });
                }
            },
            ImageView {
                visible: bind rtIconVisible
                translateX: 5
                translateY: 25
                image: bind rtIcon
                onMouseClicked: function(me:MouseEvent):Void {
                    controller.retweet(
                        tweet,
                        Point2D{
                            x: imageView.boundsInScene.minX
                            y: imageView.boundsInScene.minY+imageView.boundsInLocal.height
                        });
                }
            },
            ImageView {
                visible: bind addFavIconVisible
                translateX: 25
                translateY: 25
                image: bind addFavIcon
                onMouseClicked: function(me:MouseEvent):Void {
                    controller.favorite(tweet);
                }
            }
        ]

    };

    public override function create(): Node {
        return Group {
            content: [
                imageView,
                tweetActionButtonGroup,
                if (tweet==null) {
                    Group {
                        translateY: imageView.layoutBounds.height
                        translateX: 0
                        content: UserNodeContentRenderer {
                            user: user
                        }
                    }
                }
                else null
            ]
        };
    }
}

