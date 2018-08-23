/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package brailleprinter;

import java.awt.BorderLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.swing.text.Element;
import javax.swing.AbstractAction;
import javax.swing.ActionMap;
import javax.swing.InputMap;
import javax.swing.JComponent;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.KeyStroke;
import javax.swing.Timer;
import javax.swing.event.UndoableEditEvent;
import javax.swing.text.AbstractDocument;
import javax.swing.text.DefaultEditorKit;
import javax.swing.text.DefaultStyledDocument;
import javax.swing.undo.CannotUndoException;
import javax.swing.undo.UndoManager;
import javax.swing.undo.UndoableEdit;




/**
 *
 * @author durands
 */
public class FullBrailleEditor extends JPanel {

    public interface Compilator {
        Map<Integer, List<CompileInfo>> buildProgram(final String codeSrc);
    } 
    
    
    UndoManager undoManager;    
    RightEditorPane rightPane;
    JScrollPane jScrollPane1;
    BrailleTextPane codePane;
    TextLineNumber textLineNumber;
    Timer timerCompile;
    DefaultStyledDocument doc;
    
    BrailleEditor presenter;
    
    public void setPresenter(BrailleEditor presenter) {
        this.presenter = presenter; 
    }
            
    //Compilator compilator;
    
    public FullBrailleEditor() {
        super();
        initComponent();
        postInit();
    }
    
    protected void initComponent() {
        this.setLayout(new BorderLayout());
        
        jScrollPane1 = new JScrollPane();
        jScrollPane1.setBorder(null);
        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
        jScrollPane1.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);

        codePane = new BrailleTextPane();
        textLineNumber = new TextLineNumber(codePane);
        codePane.setBorder(null);

        jScrollPane1.setViewportView(codePane);
        jScrollPane1.setRowHeaderView(textLineNumber);

        add(jScrollPane1, java.awt.BorderLayout.CENTER);

        rightPane = new RightEditorPane();
        rightPane.setMaximumSize(new java.awt.Dimension(16, 32767));
        rightPane.setMinimumSize(new java.awt.Dimension(16, 100));
        rightPane.setPreferredSize(new java.awt.Dimension(16, 469));

        add(rightPane, BorderLayout.EAST);
    }
    
    protected void postInit() {
                codePane.setFocusTraversalKeysEnabled(false);
//...
// Our words to complete
/*
         keywords = new ArrayList<String>(5);
         keywords.add("example");
         keywords.add("autocomplete");
         keywords.add("stackabuse");
         keywords.add("java");*/
//AutoComplete autoComplete = new AutoComplete(codePane, Arrays.asList(instructions));
//doc.addDocumentListener(autoComplete);

// Maps the tab key to the commit action, which finishes the autocomplete
// when given a suggestion
//codePane.getInputMap().put(KeyStroke.getKeyStroke("TAB"), COMMIT_ACTION);
//codePane.getActionMap().put(COMMIT_ACTION, autoComplete.new CommitAction());

      //  OpenCLDoc doc = new OpenCLDoc();
    //    this.codePane.setDocument(doc);
      //  this.jSplitPane2.setTopComponent(screen);
      
        doc = new DefaultStyledDocument();
        codePane.setDocument(doc);
        doc.setDocumentFilter(new CustomDocumentFilter(codePane));
        doc.putProperty(DefaultEditorKit.EndOfLineStringProperty, "\n");
       
        undoManager = new UndoManager();
        doc.addUndoableEditListener((UndoableEditEvent e) -> {
            //if(!"style change".equals(e.getEdit().getPresentationName())) {
            UndoableEdit edit = e.getEdit();
            if (edit instanceof AbstractDocument.DefaultDocumentEvent &&
                    ((AbstractDocument.DefaultDocumentEvent)edit).getType() == AbstractDocument.DefaultDocumentEvent.EventType.CHANGE) {
                return;
            }
            //    System.out.println("Add edit");
            undoManager.addEdit(e.getEdit());
            
            timerCompile.restart();
        });

        InputMap im = codePane.getInputMap(JComponent.WHEN_FOCUSED);
        ActionMap am = codePane.getActionMap();

        im.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()), "Undo");
        im.put(KeyStroke.getKeyStroke(KeyEvent.VK_Y, Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()), "Redo");

        am.put("Undo", new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    if (undoManager.canUndo()) {
                        undoManager.undo();
                    }
                } catch (CannotUndoException exp) {
                    exp.printStackTrace();
                }
            }
        });
        am.put("Redo", new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    if (undoManager.canRedo()) {
                        undoManager.redo();
                    }
                } catch (CannotUndoException exp) {
                    exp.printStackTrace();
                }
            }
        });

        timerCompile = new Timer(2000, (ActionEvent e) -> {
                    final Map<Integer, List<CompileInfo>> lstInfo1 = doBuildProgram(codePane.getText());
                    codePane.setCompileInfo(lstInfo1);
                    rightPane.setCompileInfo(lstInfo1, codePane);
                    textLineNumber.setCompileInfo(lstInfo1);
                });
        timerCompile.setRepeats(false);
    
    }

//    public void setDocument(final Document doc) {
//        codePane.setDocument(doc);
//        // TODO recompile
//    }
    public void setText(final String srcCode) {
        codePane.setText(srcCode);
        // TODO recompile
    }
    public String getText() {
        return codePane.getText();
        // TODO recompile
    }
    
//    public void setCompilator(final Compilator compilator) {
//        this.compilator = compilator;
//    }
    
    public int getLineIdOfCaret(final int pos) {
        final Element root = codePane.getDocument().getDefaultRootElement();
        return root.getElementIndex(pos)+1;
    }
        
    private Map<Integer, List<CompileInfo>> doBuildProgram(final String braille) {
        Map<Integer, List<CompileInfo>> info = new HashMap<>();
        
        String[] lines = braille.split("\n");
            
        if (lines.length > BrailleTextPane.NB_CHAR_H) {
            List<CompileInfo> errs = new ArrayList<>();
            errs.add(new CompileInfo("Texte trop long",0,BrailleTextPane.NB_CHAR_H, 0));
            info.put(BrailleTextPane.NB_CHAR_H, errs);
        }
       
        for (int i=0; i<lines.length; i++) {
            if (lines[i].length() > BrailleTextPane.NB_CHAR_W) {
                List<CompileInfo> errs = new ArrayList<>();
                errs.add(new CompileInfo("Texte trop long",0,i+1, BrailleTextPane.NB_CHAR_W));
                info.put(i+1, errs);
            }
        }  
        return info; //compilator == null ? null : compilator.buildProgram(codeSrc);
    }

    
    // -------------------------------------------------------------------------
    
    Map<Integer,List<CompileInfo>> lstInfo;
    public List<CompileInfo> getInfoAtLine(final int lineId) {
        if (lstInfo == null) return null;
        return this.lstInfo.get(lineId);
    }
    
    public String getTextErrorForLine(final int lineId) {
        return getTextErrorFor(getInfoAtLine(lineId));
    }
    
    public String getTextErrorFor(final List<CompileInfo> lst) {
        String txt = "";
        if (lst != null) {
            txt += "<html>";
            for(int i=0; i<lst.size(); i++) {
                if (i!=0) txt += "<br/>";
                txt += lst.get(i).txt;
            }
            txt += "</html>";
        }
        return txt;
    }
    
    public void setCompileInfos(Map<Integer,List<CompileInfo>> lstInfo) {
        this.lstInfo = lstInfo;
    }
    
    public Set<Integer> getLinesWithInfos() {
        return lstInfo != null ? lstInfo.keySet() : null;
    }
    
    public Map<Integer,List<CompileInfo>> getCompileInfos() {
        return lstInfo;
    }

}
