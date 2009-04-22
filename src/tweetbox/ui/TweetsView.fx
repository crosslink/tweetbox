/*
 * TweetsView.fx
 *
 * Created on 31-okt-2008, 9:33:30
 */

package tweetbox.ui;

import javafx.scene.*;
import javafx.scene.shape.*;
import javafx.scene.layout.*;

import twitter4j.TwitterResponse;

import tweetbox.generic.component.ListBox;
import tweetbox.generic.component.Button;
import tweetbox.valueobject.TweetVO;
import tweetbox.valueobject.GroupVO;
import tweetbox.ui.style.Style;

/**
 * @author mnankman
 */
public class TweetsView extends CustomNode, Resizable {

    public var group:GroupVO;
    public var minimizedHeight:Number;
    public var minimizedWidth:Number;

    var expanded:Boolean = bind group.expanded;

    public var onHide:function(group:GroupVO):Void;
    
    var newTweets:Integer = bind group.newUpdates on replace {
        var updateArray:Object[] = group.updates.toArray();
        var addedRows:Integer = 0;
        for (row in [0..newTweets - 1]) {
            insert TweetNode {
                width: width - 5
                height: 80
                tweet: TweetVO {
                    response: updateArray[row] as TwitterResponse
                }
            } before tweetListModel[row];
//            insert TweetVO {
//                response: updateArray[row] as TwitterResponse
//            } before tweetListModel[row];
        }
        delete tweetListModel[group.maxVisibleUpdates..];
        newRows = newTweets;
    };

    var title:String = bind group.title;
                
    var newRows:Integer = 0;
            
    var nodeStyle = bind Style.getApplicationStyle();

    var tweetListModel: Object[] = [];

    var view:Group = Group {
        visible: bind expanded
        content: [
            Rectangle {
                stroke: bind nodeStyle.TWEETSVIEW_STROKE
                fill: null;
                x:0
                y:0
                width: width
                height: bind height
            },
            TitleBar {
                translateX: 2
                translateY:2
                title: bind "{title} ({newRows})"
                width: width - 1

                buttons: [
                    Button {
                        imageURL: "{__DIR__}icons/refresh.png"
                        width: 14
                        height: 14
                        action: group.refresh;
                    },
                    Button {
                        label: "-"
                        width: 14
                        height: 14
                        action: function() {
                            group.expanded = false;
                            onHide(group);
                        }
                    }
                ]

            },
            ListBox {
                translateX: 5
                translateY: 25
                height: bind height - 35
                width: width - 20
                model: bind tweetListModel
                cellHeight: 80
                cellRenderer: TweetCellRenderer{}
            }

        ]
    }

    public override function create(): Node {
        return view;
    }

    public override function toString():String {
        return "TweetsView[title = {title}, newTweets = {newTweets}, expanded = {expanded}] ";
    }

}