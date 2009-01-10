/*
 * State.fx
 *
 * Created on 7-nov-2008, 15:04:23
 */

package tweetbox.model;

/**
 * @author mnankman
 */

public var READY:Integer = 0;
public var ERROR:Integer = 1;
public var RETRIEVING_TIMELINE:Integer = 2;
public var RETRIEVING_REPLIES:Integer = 3;
public var RETRIEVING_DIRECT_MESSAGES:Integer = 4;
public var RETRIEVING_SEARCHRESULTS:Integer = 5;
public var SENDING_UPDATE:Integer = 6;
public var EXITING:Integer = 7;
