/*
 * Command.fx
 *
 * Created on 8-nov-2008, 17:03:40
 */

package tweetbox.generic.command;
import org.jfxtras.async.JFXWorker;

/**
 * @author mnankman
 */

public abstract class AbstractCommand {
    public-init var onDone:function(result:Object): Void;
    public-init var onFailure:function(error:Object): Void;

    public function run(): Void {
        var worker:JFXWorker = JFXWorker {
            inBackground: execute
            onDone: function(result:Object): Void {
                onDone(result);
            }
            onFailure: function(error:Object): Void {
                onFailure(error);
            }
        }
    }

    public abstract function execute(): Object;
}
