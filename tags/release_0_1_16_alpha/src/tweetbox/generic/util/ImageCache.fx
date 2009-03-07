/*
 * CachingImage.fx
 *
 * Created on 15-jan-2009, 16:32:21
 */

package tweetbox.generic.util;

import javafx.scene.image.Image;
import java.util.Map;

/**
 * @author mnankman
 */


public class ImageCache  {

    var cachedImagesMap:Map = new java.util.HashMap();

    public function getImage(url:String): Image {
        return getImage(url, null);
    }

    public function getImage(url:String, placeholder:Image): Image {
        if (cachedImagesMap.containsKey(url)) {
            return cachedImagesMap.get(url) as Image
        }
        else {
            var newImage:Image = Image {
                placeholder: placeholder
                backgroundLoading: true
                url: url
            }
            cachedImagesMap.put(url, newImage);
            return newImage;
        }
    }

}

//-----------------Use Singleton pattern to get instance -----------------------
var instance:ImageCache;

public function getInstance():ImageCache {
    if (instance == null) {
        instance = ImageCache {

        };

    }
    else {
        instance;
    }
}
