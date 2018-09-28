///*
// * To change this license header, choose License Headers in Project Properties.
// * To change this template file, choose Tools | Templates
// * and open the template in the editor.
// */
//package brailleprinter;
//
//
//import java.awt.geom.Path2D;
//import java.io.BufferedReader;
//import java.io.File;
//import java.io.FileInputStream;
//import java.io.FileNotFoundException;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.io.UnsupportedEncodingException;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//import javax.swing.JFrame;
//
///**
// *
// * @author durands
// */
//public class BraillePrinter {
//    
//    static final int maxCharW = 37, maxCharH = 27;
//
//            
//    static final int[] braillePosX = { 0,0,0,1,1,1,0,1 };
//    static final int[] braillePosY = { 0,1,2,0,1,2,3,3 };
//    static final int[] brailleOrder = { 0,1,2,6,7,5,4,3 };
//    static final int[] brailleOrderInv = { 3,4,5,7,6,2,1,0 };
//    
//    public static void addDotsPositions(Path2D moves, char unicode, double x0, double y0, double scale, boolean inverseX) {
//        int v = (unicode-0x2800);
//        if (inverseX) {
//            for (int id : brailleOrderInv) {
//                if ((v & (1<<id)) != 0) {
//                    moves.lineTo(x0+scale*braillePosX[id], y0+scale*braillePosY[id]);
//                }
//            }
//        } else {
//            for (int id : brailleOrder) {
//                if ((v & (1<<id)) != 0) {
//                    moves.lineTo(x0+scale*braillePosX[id], y0+scale*braillePosY[id]);
//                }
//            }
//        }
//               
//    }
//    
// 
////braille unicode
////0x2800 +
//// 1   8        1  4
//// 2  16        2  5
//// 4  32        3  6
////64 128        7  8
//    
// 
//    /*
//    boolean[] listPos(char unicode) {
//        int val = unicode - 0x2800;
//        boolean[] tab = new boolean[8];
//        for (int i=0; i<8; i++) {
//            tab[i] = ((val & 1<<i) != 0);
//        }
//        return tab;
//    }
//    */
//  //  int[] listMoves() {
//            // order : 1 -> 2 -> 3 -> 7 -> 8 -> 6 -> 5 -> 4
//  //  }
//
//    
//    public static String readFile(final String filePath) {
//        try {
//            FileInputStream fis = new FileInputStream(new File(filePath));
//            InputStreamReader inputStreamReader = new InputStreamReader((InputStream)fis, "UTF-8");
//            BufferedReader br = new BufferedReader(inputStreamReader);
//            String line;
//            StringBuilder sb = new StringBuilder();
//            while ((line = br.readLine()) != null) {
//                sb.append(line).append("\n");
//            } 
//            return sb.toString();
//            
//        } catch (FileNotFoundException ex) {
//            Logger.getLogger(BraillePrinter.class.getName()).log(Level.SEVERE, null, ex);
//        } catch (UnsupportedEncodingException ex) {
//            Logger.getLogger(BraillePrinter.class.getName()).log(Level.SEVERE, null, ex);
//        } catch (IOException ex) {
//            Logger.getLogger(BraillePrinter.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        return null;
//    }
//
//    public static Path2D txtToPath(List<List<Character>> arr, double marginX, double marginY, double scale, double charSpace, double lineSpace) {
//        double x0 = marginX;
//        double y0 = marginY;
//        boolean inversed = false;
//       
//        Path2D moves = new Path2D.Double();
//        moves.moveTo(x0, y0);
//
//        for (int lineId=0; lineId<arr.size(); lineId++) {
//            while (arr.get(lineId).isEmpty())
//                lineId++;
//            
//            List<Character> line = arr.get(lineId);
//
//            for (int charId=0; charId< line.size(); charId++) {
//                int chId = inversed ? line.size()-charId-1 : charId;
//                Character ch = line.get(chId);
//                addDotsPositions(moves, ch, marginX+chId*charSpace, marginY+lineId*lineSpace, scale, inversed); 
//            } 
//            inversed = !inversed;
//        }
//        return moves;
//    }
//
//
//    
//     
//    /**
//     * @param args the command line arguments
//     */
//    public static void main(String[] args) {
//        // TODO code application logic here
//       // initAsciiBrailleConverter();
///*
//        String fullAsciiToUnicode6_3 = "";
//        for (int i=0; i<fullAsciiToUnicode6_2.length(); i++) {
//            Character unicode = fullAsciiToUnicode6_2.charAt(i);
//            fullAsciiToUnicode6_3 += (unicode-EMPTY) + ",";
//        }
//*/  
//        String file = "C:\\Users\\durands\\Desktop\\EngagesFormat-txt_nat.txt";
//        String txt = readFile(file);
//        
//        String sTranslated = AsciiBrailleConverter.toBraille(txt);
//
//        
//        
//        List<List<List<Character>>> chPages = AsciiBrailleConverter.getBrailleArray(txt, maxCharW, maxCharH);
//
//        double  A4W = 210, A4H = 297,
//                marginW = 10,
//                marginH = 10,
//                charSpace = (A4W-2*marginW)/maxCharW,
//                lineSpace = (A4H-2*marginH)/maxCharH,
//                scale = Math.min(charSpace/2.5, lineSpace/4);
//
//        // Tansform doc to path
//        List<Path2D> drawingPath = new ArrayList();
//        for (List<List<Character>> chPage : chPages) {
//            drawingPath.add(txtToPath(chPage, marginW, marginH, scale, charSpace, lineSpace));            
//        }
//        
//        // TODO send pages to printer
//        // Display
//
//        JFrame frame = new JFrame();
//
//        frame.setSize(800, 1000);
//        PreviewPanel panel = new PreviewPanel(drawingPath.get(0));
//        frame.setContentPane(panel);
//        frame.setVisible(true);
//        
//     //   AffineTransform at = new AffineTransform();
//     //   panel.animatePanel(at, drawingPath.isEmpty() ? null : drawingPath.get(0), panel);
//        
//    }
//    
//}
