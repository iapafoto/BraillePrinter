/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package brailleprinter;


import java.awt.geom.Path2D;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.swing.JFrame;

/**
 *
 * @author durands
 */
public class BraillePrinter {
    
    static final char EMPTY = (char)0x2800;
    static final char UNKNOWN = (char)0;

    static final String asciiToBraille6_1 = " A1B'K2L@CIF/MSP\"E3H9O6R^DJG>NTQ,*5<-U8V.%[$+X!&;:4\\0Z7(_?W]#Y)=";
    static final String asciiToBraille6_2 = "⠀⠁⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟⠠⠡⠢⠣⠤⠥⠦⠧⠨⠩⠪⠫⠬⠭⠮⠯⠰⠱⠲⠳⠴⠵⠶⠷⠸⠹⠺⠻⠼⠽⠾⠿";
    //String braille8Unicode_2 = " ⠂⠄⠆⠈⠊⠌⠎⠐⠒⠔⠖⠘⠚⠜⠞⠠⠢⠤⠦⠨⠪⠬⠮⠰⠲⠴⠶⠸⠺⠼⠾⡀⡂⡄⡆⡈⡊⡌⡎⡐⡒⡔⡖⡘⡚⡜⡞⡠⡢⡤⡦⡨⡪⡬⡮⡰⡲⡴⡶⡸⡺⡼⡾⢂⢆⢊⢎⢐⢒⢔⢖⢚⢜⢞⢢⢦⢪⢮⢰⢲⢴⢶⢺⢼⢾⣊⣎⣔⣚⣦⣪⣴⣶⣺";

    static final String asciiToBraille8_1 = " !\"#$%&'()*+,-./0123456789;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    static final String asciiToBraille8_2 = " ⡜⠠⡸⡖⡒⡞⠈⡮⡼⡂⡘⡢⡈⡐⠘⡨⠄⠌⠤⡤⡄⠬⡬⡌⠨⡠⡆⡾⠸⡲⠐⢂⢆⢒⢲⢢⢖⢶⢦⢔⢴⢊⢎⢚⢺⢪⢞⢾⢮⢜⢼⣊⣎⣴⣚⣺⣪⡔⡦⡶⠰⡰⢐⠂⠆⠒⠲⠢⠖⠶⠦⠔⠴⠊⠎⠚⠺⠪⠞⠾⠮⠜⠼⡊⡎⡴⡚⡺⡪⣔⣦⣶⢰";

    static final String braille8Unicode_1 = " a1b'k2l@cif/msp\"e3h9o6r^djg>ntq,*5<-u8v.%[$+x!&;,4\\0z7(_?w]#y)=ABKL`CIFMSPEHOR~DJGNTQUV{X|ZW}Y";
    static final String braille8Unicode_2 = " ⠂⠄⠆⠈⠊⠌⠎⠐⠒⠔⠖⠘⠚⠜⠞⠠⠢⠤⠦⠨⠪⠬⠮⠰⠲⠴⠶⠸⠺⠼⠾⡀⡂⡄⡆⡈⡊⡌⡎⡐⡒⡔⡖⡘⡚⡜⡞⡠⡢⡤⡦⡨⡪⡬⡮⡰⡲⡴⡶⡸⡺⡼⡾⢂⢆⢊⢎⢐⢒⢔⢖⢚⢜⢞⢢⢦⢪⢮⢰⢲⢴⢶⢺⢼⢾⣊⣎⣔⣚⣦⣪⣴⣶⣺";
    
    
    // valable de 32 a 32+128 (faire char-32 pour mapper correctement)
    static final String fullAsciiToUnicode6_1 = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~";
    static final String fullAsciiToUnicode6_2 = "⠀⠮⠐⠼⠫⠩⠯⠄⠷⠾⠡⠬⠠⠤⠨⠌⠴⠂⠆⠒⠲⠢⠖⠶⠦⠔⠱⠰⠣⠿⠜⠹⠈⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏⠟⠗⠎⠞⠥⠧⠺⠭⠽⠵⠪⠳⠻⠘⠸⠀⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏⠟⠗⠎⠞⠥⠧⠺⠭⠽⠵⠀⠀⠀⠀⠀";

    static final int[] braillePosX = { 0,0,0,1,1,1,0,1 };
    static final int[] braillePosY = { 0,1,2,0,1,2,3,3 };
    static final int[] brailleOrder = { 0,1,2,6,7,5,4,3 };
    static final int[] brailleOrderInv = { 3,4,5,7,6,2,1,0 };
    
    public static void addDotsPositions(Path2D moves, char unicode, double x0, double y0, double scale, boolean inverseX) {
        int v = (unicode-0x2800);
        if (inverseX) {
            for (int id : brailleOrderInv) {
                if ((v & (1<<id)) != 0) {
                    moves.lineTo(x0+scale*braillePosX[id], y0+scale*braillePosY[id]);
                }
            }
        } else {
            for (int id : brailleOrder) {
                if ((v & (1<<id)) != 0) {
                    moves.lineTo(x0+scale*braillePosX[id], y0+scale*braillePosY[id]);
                }
            }
        }
               
    }
    
 
//braille unicode
//0x2800 +
// 1   8        1  4
// 2  16        2  5
// 4  32        3  6
//64 128        7  8
    
    static class AsciiBrailleConverter {
        public static SortedMap<Character, Character> mapAsciiToUnicodeBraille = new TreeMap();
        public static SortedMap<Character, Character> mapUnicodeBrailleToAscii = new TreeMap();
        
        void put(char ascii, int... dots) {
            char unicode = 0x2800;
            for(int c : dots) {
                unicode += 1<<c; 
            }
            mapAsciiToUnicodeBraille.put(ascii, unicode);
            mapUnicodeBrailleToAscii.put(unicode, ascii);
        }
        
        void put(String ascii, String unicode) {
            for(int i=0; i<ascii.length(); i++) {
                mapAsciiToUnicodeBraille.put(ascii.charAt(i), unicode.charAt(i));
                mapUnicodeBrailleToAscii.put(unicode.charAt(i), ascii.charAt(i));
            }
        }
        
        void printAll() {
            String ascii = "";
            String unicode = "";
            for(char c : mapAsciiToUnicodeBraille.keySet()) {
                ascii += c;
            }
            for(char c : mapAsciiToUnicodeBraille.values()) {
                unicode += c;
            }
            System.out.println(ascii);
            System.out.println(unicode);
            
            ascii = "";
            unicode = "";
            for(char c : mapUnicodeBrailleToAscii.keySet()) {
                ascii += c;
            }
            for(char c : mapUnicodeBrailleToAscii.values()) {
                unicode += c;
            }
            
            System.out.println(ascii);
            System.out.println(unicode);
            
            ascii = "";
            unicode = "";
            for(char c=32; c<128;c++) {
                ascii += c>='a'&&c<='z'?(char)(c-('a'-'A')):c;
            }
            for(char c=32; c<128;c++) {
                
                Character un = mapAsciiToUnicodeBraille.get(c>='a'&&c<='z'?(char)(c-('a'-'A')):c);
                unicode += un == null ? EMPTY : un;
            }
            
            System.out.println("Full ascii map");
            System.out.println(ascii);
            System.out.println(unicode);
        }
    }


//AsciiBrailleConverter m = new AsciiBrailleConverter();

    static void initAsciiBrailleConverter() {
        AsciiBrailleConverter m = new AsciiBrailleConverter();
        
        m.put(asciiToBraille6_1, asciiToBraille6_2);
       /* 
        m.put('!' , 2,3,4,6);
	m.put('\"', 5);
	m.put('#' , 3,4,5,6);
	m.put('$' , 1,2,4,6);
	m.put('%' , 1,4,6);
	m.put('&' , 1,2,3,4,6);
	m.put('\'' , 3);
	m.put('(' , 1,2,3,5,6);
	m.put(')' , 2,3,4,5,6);
	m.put('*' , 1,6);
	m.put('+' , 3,4,6);
	m.put(',' , 6);
	m.put('-' , 3,6);
	m.put('.' , 4,6);
	m.put('/' , 3,4);
	m.put('0' , 3,5,6);
	m.put('1' , 2);
	m.put('2' , 2,3);
	m.put('3' , 2,5);
	m.put('4' , 2,5,6);
	m.put('5' , 2,6);
	m.put('6' , 2,3,5);
	m.put('7' , 2,3,5,6);
	m.put('8' , 2,3,6);
	m.put('9' , 3,5);
	m.put(',' , 1,5,6);
	m.put(';' , 5,6);
	m.put('<' , 1,2,6);
	m.put('=' , 1,2,3,4,5,6);
	m.put('>' , 3,4,5);
	m.put('?' , 1,4,5,6);
	m.put('@' , 4);
	m.put('A' , 1,7);
	m.put('B' , 1,2,7);
	m.put('C' , 1,4,7);
	m.put('D' , 1,4,5,7);
	m.put('E' , 1,5,7);
	m.put('F' , 1,2,4,7);
	m.put('G' , 1,2,4,5,7);
	m.put('H' , 1,2,5,7);
	m.put('I' , 2,4,7);
	m.put('J' , 2,4,5,7);
	m.put('K' , 1,3,7);
	m.put('L' , 1,2,3,7);
	m.put('M' , 1,3,4,7);
	m.put('N' , 1,3,4,5,7);
	m.put('O' , 1,3,5,7);
	m.put('P' , 1,2,3,4,7);
	m.put('Q' , 1,2,3,4,5,7);
	m.put('R' , 1,2,3,5,7);
	m.put('S' , 2,3,4,7);
	m.put('T' , 2,3,4,5,7);
	m.put('U' , 1,3,6,7);
	m.put('V' , 1,2,3,6,7);
	m.put('W' , 2,4,5,6,7);
	m.put('X' , 1,3,4,6,7);
	m.put('Y' , 1,3,4,5,6,7);
	m.put('Z' , 1,3,5,6,7);
	m.put('[' , 2,4,6);
	m.put('\\', 1,2,5,6);
	m.put(']' , 1,2,4,5,6);
	m.put('^' , 4,5);
	m.put('_' , 4,5,6);
	m.put('`' , 4,7);
	m.put('a' , 1);
	m.put('b' , 1,2);
	m.put('c' , 1,4);
	m.put('d' , 1,4,5);
	m.put('e' , 1,5);
	m.put('f' , 1,2,4);
	m.put('g' , 1,2,4,5);
	m.put('h' , 1,2,5);
	m.put('i' , 2,4);
	m.put('j' , 2,4,5);
	m.put('k' , 1,3);
	m.put('l' , 1,2,3);
	m.put('m' , 1,3,4);
	m.put('n' , 1,3,4,5);
	m.put('o' , 1,3,5);
	m.put('p' , 1,2,3,4);
	m.put('q' , 1,2,3,4,5);
	m.put('r' , 1,2,3,5);
	m.put('s' , 2,3,4);
	m.put('t' , 2,3,4,5);
	m.put('u' , 1,3,6);
	m.put('v' , 1,2,3,6);
	m.put('w' , 2,4,5,6);
	m.put('x' , 1,3,4,6);
	m.put('y' , 1,3,4,5,6);
	m.put('z' , 1,3,5,6);
	m.put('{' , 2,4,6,7);
	m.put('|' , 1,2,5,6,7);
	m.put('}' , 1,2,4,5,6,7);
	m.put('~' , 4,5,7);
        */
        m.printAll();
    }    
    /*
    boolean[] listPos(char unicode) {
        int val = unicode - 0x2800;
        boolean[] tab = new boolean[8];
        for (int i=0; i<8; i++) {
            tab[i] = ((val & 1<<i) != 0);
        }
        return tab;
    }
    */
  //  int[] listMoves() {
            // order : 1 -> 2 -> 3 -> 7 -> 8 -> 6 -> 5 -> 4
  //  }

    
    public static String readFile(final String filePath) {
        try {
            FileInputStream fis = new FileInputStream(new File(filePath));
            InputStreamReader inputStreamReader = new InputStreamReader((InputStream)fis, "UTF-8");
            BufferedReader br = new BufferedReader(inputStreamReader);
            String line;
            StringBuilder sb = new StringBuilder();
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            } 
            return sb.toString();
            
        } catch (FileNotFoundException ex) {
            Logger.getLogger(BraillePrinter.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(BraillePrinter.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(BraillePrinter.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public static Path2D txtToPath(List<List<Character>> arr, double marginX, double marginY, double scale, double charSpace, double lineSpace) {
        double x0 = marginX;
        double y0 = marginY;
        boolean inversed = false;
       
        Path2D moves = new Path2D.Double();
        moves.moveTo(x0, y0);

        for (int lineId=0; lineId<arr.size(); lineId++) {
            while (arr.get(lineId).isEmpty())
                lineId++;
            
            List<Character> line = arr.get(lineId);

            for (int charId=0; charId< line.size(); charId++) {
                int chId = inversed ? line.size()-charId-1 : charId;
                Character ch = line.get(chId);
                addDotsPositions(moves, ch, marginX+chId*charSpace, marginY+lineId*lineSpace, scale, inversed); 
            } 
            inversed = !inversed;
        }
        return moves;
    }

    public static List<List<List<Character>>> getBrailleArray(String txt, int maxCharsByLine, int maxLinesByPage) {
        List<List<List<Character>>> chPages =  new ArrayList();
        List<List<Character>> chPage;
        List<Character> chLine;

        final String[] pages = txt.split("\\f");

        for (String page : pages) {
           // pagesLinesChars
            chPage = new ArrayList();
            chPages.add(chPage);

            final String[] lines = page.split("\\r?\\n");
            for (String line : lines) {
                if (chPage.size()>maxLinesByPage) { // Trop de lignes on ajoute une page
                    chPage = new ArrayList();
                    chPages.add(chPage);
                }
                
                chLine = new ArrayList();
                chPage.add(chLine);

                for (int i=0; i<line.length(); i++) { // TODO faire une ligne sur deux en sens inverse
                    char ch = line.charAt(i);
                    if (ch == '\t') {
                        if (chLine.size() < maxCharsByLine) chLine.add(EMPTY);
                        if (chLine.size() < maxCharsByLine) chLine.add(EMPTY);
                        if (chLine.size() < maxCharsByLine) chLine.add(EMPTY);
                    } else if (ch >= 0x2800 && ch <= 0x28FF) { // Deja de l'unicode Braille 
                        chLine.add(ch);
                    } else if (ch >= 32 && ch < 127) { // ASCII
                        Character unicode = fullAsciiToUnicode6_2.charAt(ch-32);
                        Character unicode2 = AsciiBrailleConverter.mapAsciiToUnicodeBraille.get(ch);
                        if (unicode2 != null && unicode2.equals(unicode)) {
                            int test = 1;
                        }
                        chLine.add(unicode);
                    } else {
                        chLine.add(UNKNOWN);
                    }

                    if (chLine.size() > maxCharsByLine) {
                        // Commencement d'une nouvelle ligne si ca depasse (on pourrait aussi tronquer => break)
                        chLine = new ArrayList();
                        chPage.add(chLine);
                    }
                }
            }
        }
        
        return chPages;
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        initAsciiBrailleConverter();

        String file = "C:\\Users\\durands\\Desktop\\texte-txt_nat.txt";
        String txt = readFile(file);
        
        int maxCharW = 37, maxCharH = 27;
        
        List<List<List<Character>>> chPages = getBrailleArray(txt, maxCharW, maxCharH);

        double  A4W = 210, A4H = 297,
                marginW = 10,
                marginH = 10,
                charSpace = (A4W-2*marginW)/maxCharW,
                lineSpace = (A4H-2*marginH)/maxCharH,
                scale = Math.min(charSpace/2.5, lineSpace/4);

        // Tansform doc to path
        List<Path2D> drawingPath = new ArrayList();
        for (List<List<Character>> chPage : chPages) {
            drawingPath.add(txtToPath(chPage, marginW, marginH, scale, charSpace, lineSpace));            
        }
        
        // TODO send pages to printer
        // Display

        JFrame frame = new JFrame();

        frame.setSize(800, 1000);
        PreviewPanel panel = new PreviewPanel(drawingPath.get(0));
        frame.setContentPane(panel);
        frame.setVisible(true);
        
     //   AffineTransform at = new AffineTransform();
     //   panel.animatePanel(at, drawingPath.isEmpty() ? null : drawingPath.get(0), panel);
        
    }
    
}
