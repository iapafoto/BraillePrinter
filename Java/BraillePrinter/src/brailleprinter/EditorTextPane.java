/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package brailleprinter;

import java.awt.Font;
import java.awt.FontFormatException;
import java.awt.Point;
import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JTextPane;
import javax.swing.text.DefaultEditorKit;
import javax.swing.text.Element;

/**
 *
 * @author durands
 */
public class EditorTextPane extends JTextPane {
    
    public EditorTextPane() {
        super();
        
        try {
            InputStream is = BrailleTextPane.class.getResourceAsStream("FreeMono.ttf");
            Font font = Font.createFont(Font.TRUETYPE_FONT, is);
            setFont(font.deriveFont(24f));
        } catch (FontFormatException | IOException ex) {
            Logger.getLogger(BrailleTextPane.class.getName()).log(Level.SEVERE, null, ex);
        }
        this.getDocument().putProperty(DefaultEditorKit.EndOfLineStringProperty, "\n");
     //   changeLineSpacing(this, .8f, false);
    }
        
    @Override
    public boolean getScrollableTracksViewportWidth() {
        return getUI().getPreferredSize(this).width  <= getParent().getSize().width;
    }
    
    public int lineIdFromPos(Point pt) {
        final int rowStartOffset = viewToModel( pt );
        final Element root = getDocument().getDefaultRootElement();
        return root.getElementIndex(rowStartOffset) +1;
    }
}
