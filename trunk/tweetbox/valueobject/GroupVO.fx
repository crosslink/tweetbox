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
    public var newUpdates:Integer;
    public var updates:java.util.List;
    public var filter:String;
    public var imageURL:String;
    public var expanded:Boolean=false;
}
