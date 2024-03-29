/*
 *  Model.fx - 
 *  The model behind TweetBox
 */
package tweetbox.model;

import javafx.geometry.Point2D;

import tweetbox.valueobject.*;
import tweetbox.ui.style.*;
import tweetbox.configuration.Configuration;
import tweetbox.twitter.UserMap;

/**
 * The model behind TweetBox
 */
public class Model {

    public var state:Integer;
    public var error:String = "no error";
    public var errors:String[] = [];
    public var isError:Boolean;
   
    public var updateText:String;
    public var inReplyToId: Integer = -1;
    public var updateNodeVisible:Boolean = false;
    public var updateNodePosition:Point2D = Point2D {
        x: 0
        y: 0
    };
    public var directMessageMode:Boolean = false;
    public var directMessageReceiver:UserVO;

    public var needLoginCredentials:Boolean = false;

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
        title:"You"
        imageURL: "{__DIR__}../ui/icons/user.png"
        showAlerts:false
    }

    public var favorites:GroupVO = GroupVO {
        id: "favorites"
        title:"Favorites"
        imageURL: "{__DIR__}../ui/icons/heart.png"
        showAlerts:false
    }

    public var groups:GroupVO[] = [
        friendUpdates,
        replies,
        directMessages,
        favorites,
        userUpdates
    ];

    public-read var userMap:UserMap = new UserMap();

    public-read def appInfo = AppInfoVO {};

    public-read def config:Configuration = Configuration {
        groups: bind groups
    }

    public-read def themes:Theme[] = [
        MeshStyle.create(),
        GallacticBrilliance.create(),
        BlackAndBlueStyle.create()
    ];



    public var alertMessages:Object[] = [];
    public var alertMessageCount:Integer = 0;
    
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
