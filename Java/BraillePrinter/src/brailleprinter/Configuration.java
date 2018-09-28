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
