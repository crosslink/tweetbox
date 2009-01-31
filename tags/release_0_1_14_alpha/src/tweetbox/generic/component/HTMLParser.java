/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package tweetbox.generic.component;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.StringReader;
import java.net.URL;
import javax.swing.text.html.parser.Parser;
import javax.swing.text.html.parser.DTD;
import javax.swing.text.html.HTMLEditorKit;

/**
 *
 * @author mnankman
 */
public class HTMLParser extends HTMLEditorKit {

    public HTMLParser() {
        super();
    }

    public HTMLEditorKit.Parser getParser() {
        return super.getParser();
    }

    public void parse(URL url, String encoding, HTMLOutliner outliner) throws IOException {
        HTMLEditorKit.Parser parser = getParser();
        InputStream in = url.openStream();
        InputStreamReader r = new InputStreamReader(in, encoding);
        parser.parse(r, outliner, true);
    }

    public void parse(String htmlString, HTMLOutliner outliner) throws IOException {
        HTMLEditorKit.Parser parser = getParser();
        Reader r = new StringReader(htmlString);
        parser.parse(r, outliner, true);
    }
}
