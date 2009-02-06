/*
 * CustomConfigNode.fx
 *
 * Created on 6-feb-2009, 16:16:13
 */

package tweetbox.configuration;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;

/**
 * @author mnankman
 */

public abstract class CustomConfigNode extends CustomNode {
    public abstract function apply(): Void;
}