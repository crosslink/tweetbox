/*
 * HomeView.fx
 *
 * Created on 8-jan-2009, 14:13:41
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;

import tweetbox.model.Model;

import tweetbox.valueobject.GroupVO;
import tweetbox.generic.component.ScrollView;

/**
 * @author mnankman
 */

public class HomeView extends CustomNode {
    public var width:Number;
    public var height:Number;

    var model = Model.getInstance();

    var expandedTweetsView:TweetsView = null;

    var groupButtonHeight:Integer = 90;
    var groupButtonWidth:Integer = 130;

    var expandedTweetsViewMinimalWidth:Integer = 300;
    var expandedTweetsViewHeight:Number = bind height - 30;
    var expandedTweetsViewWidth:Number = 360;

    var tweetsViews:TweetsView[] = for (group:GroupVO in model.groups) {
        TweetsView {
            group: bind group
            height: bind expandedTweetsViewHeight
            width: bind expandedTweetsViewWidth
            onHide: onHideTweetsView
        }
    };

    var groupNodes:GroupNode[] = for (group:GroupVO in model.groups) {
        GroupNode {
            group: bind group
            height: bind groupButtonHeight
            width: bind groupButtonWidth
            onShowGroup: onShowTweetsView
            onHideGroup: onHideTweetsView
        }
    };

    
    public override function create(): Node {
        return HBox {
            spacing: 10
            content: [
                ScrollView {
                    width: bind groupButtonWidth + 5
                    height: bind height - 20
                    content: VBox {
                        spacing: 5
                        translateX: 10
                        translateY: 20
                        content: groupNodes
                    }
                }
                ScrollView {
                    width: bind width - groupButtonWidth
                    height: bind height - 20
                    content: HBox {
                        spacing: 10
                        translateX: 10
                        translateY: 20
                        content: tweetsViews
                    }
                },
            ]
        };
    }


    function onHideTweetsView(group:GroupVO):Void {
    }

    function onShowTweetsView(group:GroupVO):Void {
    }
}