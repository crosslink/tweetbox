/*
 * GroupVO.fx
 *
 * Created on 21-nov-2008, 10:03:28
 */

package tweetbox.valueobject;

import tweetbox.twitter.TwitterResponseComparator;

/**
 * @author mnankman
 */

public class GroupVO {
    public var id:String;
    public var title:String;
    public var newUpdates:Integer = 0;
    public var updates:java.util.Set = new java.util.TreeSet(new TwitterResponseComparator());
    public var mostRecentUpdateId:Integer = -1;
    public var filter:String;
    public var imageURL:String;
    public var expanded:Boolean=false;
    public var refresh:function():Void = null;
    public var showAlerts:Boolean = true;
    public var maxVisibleUpdates:Integer = 50;
    public var cache:Boolean=false;
}
