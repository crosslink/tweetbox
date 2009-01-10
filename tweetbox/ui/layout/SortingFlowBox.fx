/*
 * SortingFlowBox.fx
 *
 * Created on 9-jan-2009, 10:41:29
 */

package tweetbox.ui.layout;

import javafx.scene.Node;
import tweetbox.util.SequenceUtil;

/**
 * @author mnankman
 */

public var SORTDIRECTION_ASCENDING = 0;
public var SORTDIRECTION_DESCENDING = 1;

public class SortingFlowBox extends FlowBox {

    public var sortDirection:Integer = SORTDIRECTION_ASCENDING;

    public var compareNodes:function(node1:Object, node2:Object): Integer;

    var comparator:java.util.Comparator = java.util.Comparator {
        public override function compare(o1:Object, o2:Object):Integer {
            return compareNodes(o1, o2);
        }

        public function equals(o1:Object, o2:Object): Boolean {
            return (compare(o1, o2) == 0);
        }
    }

    override function getContent():Node[] {
        return sortContent();
    }

    function sortContent(): Node[] {
       var sortedNodes:Node[] = javafx.util.Sequences.sort(content, comparator) as Node[];
       return sortedNodes;
    }

}
