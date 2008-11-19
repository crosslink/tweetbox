/*
 * CachingImage.fx
 *
 * Created on 5-nov-2008, 13:32:26
 */

package tweetbox.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.image.*;

/**
 * @author mnankman
 */

public class CachingImage extends CustomNode {

    public attribute url:String;
    public function create(): Node {
        return Group {
            content: ImageView {
                image: Image {url: bind url}
            }
        };
    }
}
