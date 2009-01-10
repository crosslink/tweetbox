/*
 * HomeView.fx
 *
 * Created on 8-jan-2009, 14:13:41
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.layout.Container;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import java.lang.Math;

import tweetbox.model.Model;

import tweetbox.ui.layout.FlowBox;
import tweetbox.ui.layout.SortingFlowBox;
import tweetbox.valueobject.GroupVO;

/**
 * @author mnankman
 */

public class HomeView extends CustomNode {
    public var width:Number;
    public var height:Number;

    var model = Model.getInstance();

    var expandedTweetsView:TweetsView = null;

    var minimizedTweetsViewHeight:Integer = 70;
    var minimizedTweetsViewWidth:Integer = 120;

    var expandedTweetsViewMinimalWidth:Integer = 300;
    var expandedTweetsViews:Integer = 0;
    var expandedTweetsViewHeight:Number = bind height - 20;

    var tweetsViews:TweetsView[] = for (group:GroupVO in model.groups) {
        TweetsView {
            minimized: true
            title: bind group.title
            tweets: bind group.updates
            newTweets: bind group.newUpdates
            height: bind expandedTweetsViewHeight
            width: bind expandedTweetsViewWidth()
            minimizedHeight: bind minimizedTweetsViewHeight
            minimizedWidth: bind minimizedTweetsViewWidth
            onExpand: onTweetsViewExpand
            onMinimize: onTweetsViewMinimize
        }
    };

    public override function create(): Node {
        return Group {
            content: [
                VBox {
                    var updateRef:UpdateNode;
                    spacing: 4
                    content: [
                        updateRef = UpdateNode {
                            translateY: 0
                            text: bind model.updateText
                            translateX: 10
                        },
                        SortingFlowBox {
                            orientation: FlowBox.FLOWORIENTATION_VERTICAL
                            width: bind width - 50
                            height: bind height - 20
                            spacing: 10
                            translateX: 10
                            translateY: 20
                            content: tweetsViews
                            compareNodes: function(node1:Object, node2:Object): Integer {
                                return compareTweetsViews(node1 as TweetsView, node2 as TweetsView);
                            }
                        }
                    ]
                }
            ]
        };
    }

    function compareTweetsViews(tv1:TweetsView, tv2:TweetsView): Integer {
        var result:Integer=0;
        if (not tv1.minimized and tv2.minimized) {
            // tv1 is expanded and tv2 isn't, so tv1 > tv2
            result = 1;
        }
        else if (tv1.minimized and not tv2.minimized) {
            // tv1 is minimized and tv2 isn't, so tv1 < tv2
            result = -1;
        }
        else {
            // tv1 and tv2 are both either minimized or expanded, so tv1 == tv2
            result = 0;
        }
        return result;
    }

    function expandedTweetsViewWidthCorrection():Number {
        if (expandedTweetsViews == sizeof tweetsViews)
            return 0.0
        else
            return minimizedTweetsViewWidth;
    }

    bound function expandedTweetsViewWidth(): Number {
        return Math.min(
            Math.max(
                width / expandedTweetsViews - expandedTweetsViewWidthCorrection(),
                expandedTweetsViewMinimalWidth),
            width - expandedTweetsViewWidthCorrection());
    }

    function onTweetsViewMinimize(view:TweetsView):Void {
        if (expandedTweetsViews>0) expandedTweetsViews--;
    }

    function onTweetsViewExpand(view:TweetsView):Void {
        if (expandedTweetsViews < sizeof tweetsViews) expandedTweetsViews++;
    }
}