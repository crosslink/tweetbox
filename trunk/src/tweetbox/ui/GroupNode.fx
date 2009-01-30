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

import twitter4j.TwitterResponse;
import twitter4j.Status;
import twitter4j.DirectMessage;
import twitter4j.User;

import tweetbox.generic.component.Button;
import tweetbox.valueobject.GroupVO;
import tweetbox.ui.style.Style;
import tweetbox.generic.util.ImageCache;

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
                title: bind "{title} ({numRows})"
                width: bind width-1

                buttons: [
                    Button {
                        label: "r"
                        width: 10
                        height: 10
                        action: group.refresh;
                    },
                    Button {
                        label: bind if (group.expanded) "-" else "+"
                        width: 10
                        height: 10
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
            if (numRows>0) {
                ImageView {
                    translateX: 10
                    translateY: 40

                    image: bind profileImageForMostRecentUpdate()

                    clip: Rectangle {
                        width: 50
                        height: 50
                    }

                }
            } else null
        ]
    }

    public override function create(): Node {
        return view;
    }

    bound function profileImageForMostRecentUpdate(): Image {
        var update:TwitterResponse = group.updates.get(0) as TwitterResponse;

        var user:User = 
            if (update instanceof Status) (update as Status).getUser()
            else if (update instanceof DirectMessage) (update as DirectMessage).getSender()
            else if (update instanceof User) update as User
            else null;

        return
            if (user != null) ImageCache.getInstance().getImage(user.getProfileImageURL().toString())
            else null;
    }
}