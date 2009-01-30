/*
 * GroupVO.fx
 *
 * Created on 21-nov-2008, 10:03:28
 */

package tweetbox.valueobject;

/**
 * @author mnankman
 */

public class GroupVO {
    public var id:String;
    public var title:String;
    public var newUpdates:Integer = 0;
    public var updates:java.util.List = new java.util.Vector();
    public var filter:String;
    public var imageURL:String;
    public var expanded:Boolean=false;
    public var refresh:function():Void;
    public var showAlerts:Boolean=true;
}
