/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tweetbox.service.twitter;

/**
 *
 * @author mnankman
 */
public class ServiceInvocationException extends Exception {

    public ServiceInvocationException(Throwable cause) {
        super(cause);
    }
    
    public ServiceInvocationException(String message, Throwable cause) {
        super(message, cause);
    }

    public ServiceInvocationException(String message) {
        super(message);
    }

    public ServiceInvocationException() {
        super();
    }
}
