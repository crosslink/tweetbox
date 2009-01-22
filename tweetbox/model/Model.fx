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

   public var config:ConfigVO = ConfigVO{}
   
   public var state:Integer;
   
   public var updateText:String;

   public var friendUpdates:GroupVO = GroupVO {
        expanded: true
        id: "friends"
        title:"Friends"
        imageURL: "{__DIR__}../ui/icons/friends.png"
    }

    public var replies:GroupVO = GroupVO {
        expanded: true
        id: "replies"
        title:"Replies"
        imageURL: "{__DIR__}../ui/icons/reply.png"
    }

    public var directMessages:GroupVO = GroupVO {
        id: "direct"
        title:"Direct Messages"
        imageURL: "{__DIR__}../ui/icons/email.png"
    }

    public var userUpdates:GroupVO = GroupVO {
        id: "user"
        title:"User"
        imageURL: "{__DIR__}../ui/icons/user.png"
    }
  
    public var groups:GroupVO[] = [
        friendUpdates,
        replies,
        directMessages,
        userUpdates
    ];

    public var alertMessages:String[] = [];
    
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
