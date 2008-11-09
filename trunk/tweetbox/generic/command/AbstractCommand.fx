/*
 * Command.fx
 *
 * Created on 8-nov-2008, 17:03:40
 */

package tweetbox.generic.command;

/**
 * @author mnankman
 */

public abstract class AbstractCommand {
    public abstract function onSuccess(result): Void;
    public abstract function onFailure(error): Void;
}
