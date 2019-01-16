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
public class Configuration {
    int WRITE_SPEED = 40;
    int MOVE_SPEED = 110;
    int NB_EMBOSS_REP = 2;
    int EMBOSS_DELAY_REP = 50; 
    int EMBOSS_DELAY_BEFORE = 10; // delais entre le dernier mouvement et le debut de l'embossage
    int EMBOSS_DURATION = 20; // 50
    int EMBOSS_DELAY_AFTER = 50; // 20

    public Configuration() {
    }
    
    public Configuration(String str) {
        //$@W:40@@M:110@@N:3@@R:50@@B:10@@D:20@@A:50@$
        String sub = str.substring(2, str.length()-4);
        String elt[] = sub.split("@@");
        for (String e : elt) {
            String kv[] = e.split(":");
            setParam(kv[0], Integer.parseInt(kv[1]));
        }
    }

    public final void setParam(String key, Integer val) {
        switch(key) {
            case "W": WRITE_SPEED = val; break;
            case "M": MOVE_SPEED = val; break;
            case "N": NB_EMBOSS_REP = val; break;
            case "R": EMBOSS_DELAY_REP = val; break;
            case "B": EMBOSS_DELAY_BEFORE = val; break;
            case "D": EMBOSS_DURATION = val; break;
            case "A": EMBOSS_DELAY_AFTER = val; break;
            default: break;
        }
    }
    
    @Override
    public String toString() {
        return "@W:" + WRITE_SPEED + "@"
                    +"@M:" + MOVE_SPEED + "@"
                    +"@N:" + NB_EMBOSS_REP + "@"
                    +"@R:" + EMBOSS_DELAY_REP  + "@"
                    +"@B:" + EMBOSS_DELAY_BEFORE  + "@"
                    +"@D:" + EMBOSS_DURATION  + "@"
                    +"@A:" + EMBOSS_DELAY_AFTER  + "@";
    }
}
