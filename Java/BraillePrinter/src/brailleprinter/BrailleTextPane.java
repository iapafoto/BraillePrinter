/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package brailleprinter;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontFormatException;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.TexturePaint;
import java.awt.geom.Area;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JTextPane;
import javax.swing.text.DefaultEditorKit;
import javax.swing.text.Element;
import javax.swing.text.MutableAttributeSet;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;

/**
 *
 * @author durands
 */
public class BrailleTextPane extends JTextPane {
    
    public final static int 
            NB_CHAR_W = 27, 
            NB_CHAR_H = 25;
    
    private final static TexturePaint 
            HASH_TEXTURE_OK = initTextureOk(),
            HASH_TEXTURE_NOK = initTextureNOk();
    
    private Map<Integer, List<CompileInfo>> lstInfo = null;
    
    public BrailleTextPane() {
        super();

        try {
            InputStream is = BrailleTextPane.class.getResourceAsStream("FreeMono.ttf");
            Font font = Font.createFont(Font.TRUETYPE_FONT, is);
            setFont(font.deriveFont(24f));
            this.getDocument().putProperty(DefaultEditorKit.EndOfLineStringProperty, "\n");
        } catch (FontFormatException | IOException ex) {
            Logger.getLogger(BrailleTextPane.class.getName()).log(Level.SEVERE, null, ex);
        }
     //   changeLineSpacing(this, .8f, false);
    }


    @Override
    public Dimension getPreferredSize() {
        // Avoid substituting the minimum width for the preferred width when the viewport is too narrow
        return getUI().getPreferredSize(this);
    };
       /**
 * Select all the text of a <code>JTextPane</code> first and then set the line spacing.
 * @param the <code>JTextPane</code> to apply the change
 * @param factor the factor of line spacing. For example, <code>1.0f</code>.
 * @param replace whether the new <code>AttributeSet</code> should replace the old set. If set to <code>false</code>, will merge with the old one.
 */
    private void changeLineSpacing(JTextPane pane, float factor, boolean replace) {
      //  pane.selectAll();
        MutableAttributeSet set = new SimpleAttributeSet(pane.getParagraphAttributes());
        StyleConstants.setLineSpacing(set, factor);
        pane.setParagraphAttributes(set, replace);
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
    
    @Override
    public void paintChildren(Graphics g) {
        Graphics2D g2 = (Graphics2D) g.create();
        FontMetrics fm = g2.getFontMetrics();
        int textHeight = fm.getHeight();
        int wChar = fm.charWidth('⠏');
     //   int wChar2 = fm.charWidth(' ');
        
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2.setRenderingHint(RenderingHints.KEY_STROKE_CONTROL, RenderingHints.VALUE_STROKE_PURE);
        g2.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
/*
        if (hightErrors != null) {
            for (List<ErrorSeg> lst : hightErrors.values()) {
                for (ErrorSeg e : lst) {
                    if (e.getOffset2() != null) {
                        underlineSeg(g2, e.getOffset2(), e.getLength2(), e.getCriticity().getColor());                  
                    }
                }
            }
        }
*/         
        Area area = new Area(new Rectangle2D.Double(0, 0, getWidth(), getHeight()));
        area.subtract(new Area(new Rectangle2D.Double(0, 0, wChar*NB_CHAR_W, textHeight*NB_CHAR_H)));
      
        if (lstInfo == null || lstInfo.isEmpty()) {
            g2.setPaint(HASH_TEXTURE_OK);
        } else {
            g2.setPaint(HASH_TEXTURE_NOK);
        }
        
        g2.fill(area);        
/*
        if (isWithErrorDisplay && currentMessage != null) {
            Map<ECriticity, List<ErrorSeg>> map = currentMessage.getErrorsByCriticity(); 

            for (Map.Entry<ECriticity, List<ErrorSeg>> e : map.entrySet()) {
                for (ErrorSeg seg : e.getValue()) {
                    try {
                        if (!seg.getProposals().isEmpty()) {
                            Rectangle rec = this.modelToView(seg.getOffset());
                            g2.setColor(Color.orange); //Color.green);
                            g2.fillRect(rec.x, rec.y + rec.height-3, wCHar, 3);
                        }
                    } catch (BadLocationException ex) {
    //            Exceptions.printStackTrace(ex);
                    }
                }
            }
        }
*/
        g2.dispose();
        super.paintChildren(g);
    }
    
    private static TexturePaint initTextureNOk() {
        BufferedImage bi = new BufferedImage(5, 5, BufferedImage.TYPE_INT_ARGB);
        Graphics2D big = bi.createGraphics();
        big.setColor(new Color(255,0,0,32));
        big.fillRect(0,0,5,5);
        big.setColor(new Color(130,0,0,64));
        big.drawLine(4,4,0,0);
        big.dispose();
        return new TexturePaint(bi, new Rectangle(0,0,5,5)); 
    }
    
    private static TexturePaint initTextureOk() {
        BufferedImage bi = new BufferedImage(5, 5, BufferedImage.TYPE_INT_ARGB);
        Graphics2D big = bi.createGraphics();
        big.setColor(new Color(0,255,0,32));
        big.fillRect(0,0,5,5);
        big.setColor(new Color(0,130,0,64));
        big.drawLine(4,4,0,0);
        big.dispose();
        return new TexturePaint(bi, new Rectangle(0,0,5,5)); 
    }

    void setCompileInfo(Map<Integer, List<CompileInfo>> lstInfo) {
        this.lstInfo = lstInfo;
        repaint();
    }
    
}
