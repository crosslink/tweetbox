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
import tweetbox.generic.component.HTMLPane;
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
import javafx.geometry.Point2D;

/**
 * @author mnankman
 */
public class TweetNode extends CustomNode {

    public var tweet:TweetVO;
    public var height:Number;
    public var width:Number;

    var tweetContentWidth:Number = width - 80;
    var tweetContentHeight:Number = height;
    
    var nodeStyle = bind Style.getApplicationStyle();
    var controller = FrontController.getInstance();
    var model = Model.getInstance();

    var tweetContentBox:Group = Group {
        translateY: 2
        //verticalAlignment: VerticalAlignment.TOP
        content: [
            UserNode {
                translateX: 5
                translateY: 10
                user: tweet.user;
                tweet: tweet;
            },
            TweetContentRenderer {
                translateX: 60
                maxWidth: tweetContentWidth
                maxHeight: tweetContentHeight
                tweet: tweet
            }
        ]
    };

    public override function create(): Node {
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
                    width: width - 4
                    height: height//bind tweetContentBox.layoutBounds.height + 4
                    arcWidth:10 
                    arcHeight:10
                    fill: bind nodeStyle.UPDATE_FILL
                },
           
                tweetContentBox,                
            ]
        };
    }
}

