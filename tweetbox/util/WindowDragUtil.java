/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tweetbox.util;

import java.awt.AWTEvent;
import java.awt.Component;
import java.awt.Point;
import java.awt.Dimension;
import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.Window;
import java.awt.event.AWTEventListener;
import java.awt.event.MouseEvent;
import java.lang.reflect.Method;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFrame;
import javax.swing.JWindow;
import javax.swing.SwingUtilities;

/**
 *
 * @author joshy
 */
public class WindowDragUtil {
    private final static boolean isMac = "Mac OS X".equals(System.getProperty("os.name"));
    
    public static void makeWindowDraggable(Window window) {
        try {
            if (window instanceof JWindow) {
                makeJWindowDraggable((JWindow)window);
            }
            
            
        } catch (Throwable ex) {
            Logger.getLogger(WindowDragUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public static void makeJWindowDraggable(JWindow w) {
        if (isMac){
            w.getRootPane().putClientProperty("apple.awt.draggableWindowBackground", true);
        } else {
            
            DragHandler dragHandler = (DragHandler)w.getRootPane().getClientProperty("DragHandler");
            if (dragHandler == null) {
                dragHandler = new DragHandler();
                w.getRootPane().putClientProperty("DragHandler", dragHandler);
            }
            //add a handler to intercept AWT drag events. If they are not handled
            //by anything else, then use them to move the window around
            Toolkit.getDefaultToolkit().addAWTEventListener(dragHandler,
                    AWTEvent.MOUSE_EVENT_MASK | AWTEvent.MOUSE_MOTION_EVENT_MASK);
        }
    }
    
    /**
     * Helper class to handle frame dragging on non Apple Platforms
     */
    private static class DragHandler implements AWTEventListener{
        private int xOffset;
        private int yOffset;
        private boolean dragging = false;
        private boolean resizing = false;

        public void eventDispatched(AWTEvent event) {
            if (event instanceof MouseEvent) {
                MouseEvent e = (MouseEvent)event;
                if (!e.isConsumed()) {
                    if (e.getID() == e.MOUSE_PRESSED && !dragging) {
                        //starting a drag
                        //figure out the difference between the point of the
                        //window and the point of the mouse event. These
                        //will form our x and y offsets
                        Window win = getWindow(e);
                        Point winPoint = win.getLocationOnScreen();
                        Point mousePoint = e.getPoint();
                        xOffset = winPoint.x - mousePoint.x; //causes xoffset to be negative
                        yOffset = winPoint.y - mousePoint.y; //causes yoffset to be negative
                        //System.out.println("winPoint: " + winPoint + ", mousePoint: " + mousePoint + ", yOffset: " + yOffset);
                        dragging = (yOffset>=-20);
                        resizing = !dragging && (yOffset<=20-win.getHeight() && xOffset<=20-win.getWidth());
                        //System.out.println("dragging = " + dragging);
                        //System.out.println("resizing = " + resizing);
                    } else if (e.getID() == e.MOUSE_DRAGGED && dragging) {
                        Window win = getWindow(e);
                        Point mousePoint = e.getPoint();
                        Point winPoint = win.getLocationOnScreen();
                        winPoint.x = mousePoint.x + xOffset;
                        winPoint.y = mousePoint.y + yOffset;
                        win.setLocation(winPoint);
                    } else if (e.getID() == e.MOUSE_RELEASED && dragging) {
                        dragging = false;
                    } else if (e.getID() == e.MOUSE_DRAGGED && resizing) {
                        /*
                        Window win = getWindow(e);
                        Rectangle bounds = win.getBounds();
                        System.out.println("current window bounds: " + bounds);
                        bounds.setSize(0-xOffset, 0-yOffset);
                        System.out.println("new window bounds: " + bounds);
                        win.setBounds(bounds);
                        JFrame frame = null;
                       
                        win.repaint(bounds.x, bounds.y, bounds.width, bounds.height);
                         */
                        //win.repaint();
                    } else if (e.getID() == e.MOUSE_RELEASED && resizing) {
                        resizing = false;
                    }                }
            }
        }
        private Window getWindow(MouseEvent evt) {
            Object src = evt.getSource();
            if (src instanceof Component) {
                return SwingUtilities.getWindowAncestor((Component)src);
            } else {
                return null;
            }
        }
    }

}
