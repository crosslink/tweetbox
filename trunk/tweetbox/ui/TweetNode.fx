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
import org.json.simple.JSONObject;
import tweetbox.ui.WrappingText;

import tweetbox.model.*;
import javafx.ext.swing.Label;
import javafx.ext.swing.ComponentView;

/**
 * @author mnankman
 */
public class TweetNode extends CustomNode {

    public attribute tweet: JSONObject;
    public attribute height:Integer;
    public attribute width:Integer;
    
  /**
   * An image of a play button to be displayed in each row of the table
   */
    public attribute buddyImage = Image {url: "{__DIR__}images/buddy.png"};
   
    public function create(): Node {
        return Group {
            var model = Model.getInstance();
            var user:JSONObject = tweet.get("user") as JSONObject;
            var profileImageUrl:String = bind if (user!=null) 
                    user.get("profile_image_url") as String 
                else 
                    tweet.get("profile_image_url") as String;
            var screenNameRef: Text;
            var statusRef: WrappingText;
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
                                        url: "{profileImageUrl}"
                                    }
                        },
                        VBox {
                            translateY: 11
                            translateX: 7
                            content: [
                                screenNameRef = Text {      
                                    content: user.get("screen_name") as String
                                    font:
                                        Font {
                                            style: FontStyle.BOLD
                                            size: 11
                                        }
                                },
                                statusRef = WrappingText {
                                    text: tweet.get("text") as String
                                    width: bind width - imageViewRef.getWidth() - 10
                                    font:
                                        Font {
                                            size: 11
                                        }
                                },
                                HBox {
                                    content: [
                                        Text {
                                            content: tweet.get("created_at").toString()
                                            font:
                                                Font {
                                                    size: 11
                                                }
                                        },
                                        Text {
                                            content: tweet.get("source").toString()
                                            font:
                                                Font {
                                                    size: 11
                                                }
                                        }
                                    ]},
                            ]
                        }
                    ]
                }
            ]
        };
    }
}

