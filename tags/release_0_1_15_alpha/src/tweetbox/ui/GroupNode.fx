/*
 * GroupNode.fx
 *
 * Created on 28-jan-2009, 9:40:53
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.image.*;
import javafx.scene.input.MouseEvent;
import javafx.scene.text.Text;

import twitter4j.TwitterResponse;
import twitter4j.Status;
import twitter4j.DirectMessage;
import twitter4j.User;

import tweetbox.generic.component.Button;
import tweetbox.valueobject.GroupVO;
import tweetbox.valueobject.UserVO;
import tweetbox.ui.style.Style;
import tweetbox.generic.util.ImageCache;
import tweetbox.generic.layout.FlowBox;
/**
 * @author mnankman
 */

public class GroupNode extends CustomNode {

    public var group:GroupVO;
    public var height:Number;
    public var width:Number;

    public var onShowGroup:function(group:GroupVO):Void;
    public var onHideGroup:function(group:GroupVO):Void;

    var newTweets:Integer = bind group.newUpdates on replace {
        numRows += newTweets;
    };

    var title:String = bind group.title;

    var numRows:Integer;

    var nodeStyle = Style.getApplicationStyle();

    var view:Group = Group {
        visible: true
        content: bind [
            Rectangle {
                fill: null
                stroke: nodeStyle.TWEETSVIEW_STROKE
                x:0
                y:0
                width: bind width
                height: bind height
            },
            TitleBar {
                translateX: 2
                translateY: 2
                title: bind "{title}"
                width: bind width-1

                buttons: [
                    Button {
                        imageURL: "{__DIR__}icons/refresh.png"
                        width: 14
                        height: 14
                        action: group.refresh;
                    },
                    Button {
                        //imageURL: bind if (group.expanded) "{__DIR__}icons/down.png" else "{__DIR__}icons/up.png"
                        label: bind if (group.expanded) "-" else "+"
                        width: 14
                        height: 14
                        action: function() {
                            if (group.expanded) {
                                group.expanded = false;
                                onHideGroup(group);
                            }
                            else {
                                group.expanded = true;
                                onShowGroup(group);
                            }
                        }
                    }
                ]
            },

            // the background of the group
            Rectangle {
                translateY: 25
                translateX: 5
                width: bind width - 9
                height: bind height - 29
                arcWidth:10
                arcHeight:10
                fill: nodeStyle.UPDATE_FILL
            },

            Text {
                translateX: width * 0.6
                translateY: height * 0.7
                content: "{numRows}"
                font: nodeStyle.GROUPNODE_TEXT_FONT
                fill: nodeStyle.GROUPNODE_TEXT_FILL
            }

            if (numRows>0) {
                UserNode {
                    scale: 0.8
                    translateX: 15
                    translateY: 30
                    user: bind userOfMostRecentUpdate()
                }
            } else null,
        ]
    }

    public override function create(): Node {
        return view;
    }

    bound function userOfMostRecentUpdate(): UserVO {
        var iterator = group.updates.iterator();
        var update:TwitterResponse = iterator.next() as TwitterResponse;

        var user:User = 
            if (update instanceof Status) (update as Status).getUser()
            else if (update instanceof DirectMessage) (update as DirectMessage).getSender()
            else if (update instanceof User) update as User
            else null;

        return
            if (user != null) UserVO {user: user}
            else null;
    }
}

import javafx.scene.Scene;
import javafx.stage.Stage;
import tweetbox.model.Model;

public function run() {
    var model:Model = Model.getInstance();
    Stage {
        x:100 y:300 width:500 height:300
        onClose: function() {
            java.lang.System.exit(0);
        }
        scene:Scene {
            content: [
                GroupNode {
                    translateX: 50
                    translateY: 50
                    width: 150
                    height: 90
                    group: model.friendUpdates
                }

            ]

        }
    }
}
