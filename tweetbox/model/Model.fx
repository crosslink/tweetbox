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
  
   public var friendUpdates:List = new Vector();
   public var newFriendUpdates:Integer;
   
   public var replies:List = new Vector();
   public var newReplies:Integer;
   
   public var directMessages:List = new Vector();
   public var newDirectMessages:Integer;

   public var userUpdates:List = new Vector();
   public var newUserUpdates:Integer = 0;

   public var allNewUpdates:Integer = bind newFriendUpdates + newReplies + newDirectMessages + newUserUpdates;
   
   /*
   public var searchResults:TweetListVO = new TweetListVO;
   public var numSearchResults:Integer = bind searchResults.numTweets;
   */

   public var config:ConfigVO = ConfigVO{}
   
   public var state:Integer;
   
   public var updateText:String;
  
    public var groups:GroupVO[] = [
        GroupVO {
            expanded: true
            id: "friends" 
            title:"Friends"
            updates: bind friendUpdates
            newUpdates: bind newFriendUpdates 
            imageURL: "{__DIR__}../ui/icons/friends.png"
        },
        GroupVO {
            id: "replies" 
            title:"Replies" 
            updates: bind replies
            newUpdates: bind newReplies
            imageURL: "{__DIR__}../ui/icons/reply.png"
        },
        GroupVO {
            id: "direct" 
            title:"Direct Messages" 
            updates: bind directMessages
            newUpdates: bind newDirectMessages
            imageURL: "{__DIR__}../ui/icons/email.png"
        },
        GroupVO {
            id: "user" 
            title:"User" 
            updates: bind userUpdates
            newUpdates: bind newUserUpdates
            imageURL: "{__DIR__}../ui/icons/user.png"
        }        
    ];
    
}

//-----------------Use Singleton pattern to get model instance -----------------------
var instance:Model;

public function getInstance():Model {
    if (instance == null) {
        instance = Model {
            state: State.READY;
        };

    }
    else {
        instance;
    }
}
