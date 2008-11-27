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
import tweetbox.valueobject.*;

/**
 * The model behind the TableNode example
 */
public class Model {
  
   public attribute friendUpdates:List = new Vector();
   public attribute newFriendUpdates:Integer;
   
   public attribute replies:List = new Vector();
   public attribute newReplies:Integer;
   
   public attribute directMessages:List = new Vector();
   public attribute newDirectMessages:Integer;

   public attribute myUpdates:List = new Vector();
   public attribute newMyUpdates:Integer = 0;

   public attribute allNewUpdates:Integer = bind newFriendUpdates + newReplies + newDirectMessages + newMyUpdates;
   
   /*
   public attribute searchResults:TweetListVO = new TweetListVO;
   public attribute numSearchResults:Integer = bind searchResults.numTweets;
   */

   public attribute config:ConfigVO = ConfigVO{}
   
   public attribute state:Integer;
   
   public attribute updateText:String;
  
    public attribute groups:GroupVO[] = [
        GroupVO {
            id: "all" 
            title:"All" 
            newUpdates: bind allNewUpdates 
            imageURL: "{__DIR__}../ui/icons/friends.png"
        },
        GroupVO {
            id: "replies" 
            title:"Replies" 
            newUpdates: bind newReplies 
            imageURL: "{__DIR__}../ui/icons/reply.png"
        },
        GroupVO {
            id: "direct" 
            title:"Direct Messages" 
            newUpdates: bind newDirectMessages
            imageURL: "{__DIR__}../ui/icons/email.png"
        }
    ];

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