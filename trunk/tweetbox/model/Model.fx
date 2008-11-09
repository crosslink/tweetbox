/*
 *  TableNodeExampleModel.fx - 
 *  The model behind the TableNode example
 *
 *  Developed 2008 by James L. Weaver (jim.weaver at lat-inc.com)
 */
package tweetbox.model;

import java.lang.Object;
import java.util.Date;
import java.util.List;
import java.util.Vector;
import javafx.scene.*;
import javafx.scene.image.*;
import javafx.scene.text.*;

/**
 * The model behind the TableNode example
 */
public class Model {
  
   public attribute tweets:List = null;
   public attribute numTweets:Integer = 0;

   public attribute searchResults:List;
   public attribute numSearchResults:Integer = 0;

   public attribute config:Config = new Config();
   
   public attribute state:Integer on replace {
   }
  
  //-----------------Use Singleton pattern to get model instance -----------------------
    private static attribute instance:Model;

    public static function getInstance():Model {
        if (instance == null) {
            instance = Model {
                state: State.READY;
            };
            
        }
        else {
            instance;
        }
    }
}