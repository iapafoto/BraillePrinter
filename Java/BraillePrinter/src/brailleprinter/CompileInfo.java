/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package brailleprinter;

/**
 *
 * @author durands
 */
public class CompileInfo {
    
    String txt;
    int kind;
    int line;
    int ch;

    public CompileInfo(String txt, int kind, int line, int ch) {
        this.txt = txt;
        this.kind = kind;
        this.line = line;
        this.ch = ch;
    }

}
