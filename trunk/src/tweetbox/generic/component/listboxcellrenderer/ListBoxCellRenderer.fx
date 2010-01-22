/*
 * AbstractListBoxCellRenderer.fx
 *
 * Created on 3-mrt-2009, 11:40:34
 */

package tweetbox.generic.component.listboxcellrenderer;

import javafx.scene.Node;
import javafx.geometry.Bounds;

/**
 * @author mnankman
 */

public abstract class ListBoxCellRenderer {
    public abstract function create(data:Object, bounds:Bounds): Node;
}
