/*
 * State.fx
 *
 * Created on 7-nov-2008, 15:04:23
 */

package tweetbox.model;

/**
 * @author mnankman
 */

public class State {
    public static attribute READY:Integer = 0;
    public static attribute ERROR:Integer = 1;
    public static attribute RETRIEVING_TIMELINE:Integer = 2;
    public static attribute RETRIEVING_SEARCHRESULTS:Integer = 3;
    public static attribute SENDING_UPDATE:Integer = 4;
    public static attribute EXITING:Integer = 5;
}
