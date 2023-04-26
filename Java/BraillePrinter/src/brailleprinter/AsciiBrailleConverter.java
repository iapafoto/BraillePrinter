/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package brailleprinter;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author durands
 */
public class AsciiBrailleConverter {

    static final char EMPTY = (char) 0x2800;
    static final char UNKNOWN = (char) 0;

    public static String CH_NUM = "⠠",
            CH_MAJ = "⠨",
            CH_MAJ_SEQ = "⠒⠨";

    // Traduit caracteres par caracteres sans aucun rafinage
    static String brailleToArduinoString(String str) {
        char[] chars = str.toCharArray();
        String ascii = "";
        for (char c : chars) {
            int pos = FULL_ASCII_TO_UNICODE_6_ANTOINE.indexOf(c);
            if (pos >= 0) {
                ascii += fullAsciiToUnicode6_1.charAt(pos);
            } else {
                ascii += " ";
            }
        }
        return ascii;
    }

    enum EType {
        DIGIT, UPPER, UPPER_SEQ, UPPER_SEQ_FIRST, UPPER_SEQ_LAST, SIMPLE, MIX_CHAR, PUNCTUATION
    };

// http://braillelog.net/chiffres-et-signes-operatoires.php
    static final String asciiToBraille6_1 = " A1B'K2L@CIF/MSP\"E3H9O6R^DJG>NTQ,*5<-U8V.%[$+X!&;:4\\0Z7(_?W]#Y)=";
    static final String asciiToBraille6_2 = "⠀⠁⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟⠠⠡⠢⠣⠤⠥⠦⠧⠨⠩⠪⠫⠬⠭⠮⠯⠰⠱⠲⠳⠴⠵⠶⠷⠸⠹⠺⠻⠼⠽⠾⠿";
    //String braille8Unicode_2 = " ⠂⠄⠆⠈⠊⠌⠎⠐⠒⠔⠖⠘⠚⠜⠞⠠⠢⠤⠦⠨⠪⠬⠮⠰⠲⠴⠶⠸⠺⠼⠾⡀⡂⡄⡆⡈⡊⡌⡎⡐⡒⡔⡖⡘⡚⡜⡞⡠⡢⡤⡦⡨⡪⡬⡮⡰⡲⡴⡶⡸⡺⡼⡾⢂⢆⢊⢎⢐⢒⢔⢖⢚⢜⢞⢢⢦⢪⢮⢰⢲⢴⢶⢺⢼⢾⣊⣎⣔⣚⣦⣪⣴⣶⣺";

    static final String asciiToBraille8_1 = " !\"#$%&'()*+,-./0123456789;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    static final String asciiToBraille8_2 = " ⡜⠠⡸⡖⡒⡞⠈⡮⡼⡂⡘⡢⡈⡐⠘⡨⠄⠌⠤⡤⡄⠬⡬⡌⠨⡠⡆⡾⠸⡲⠐⢂⢆⢒⢲⢢⢖⢶⢦⢔⢴⢊⢎⢚⢺⢪⢞⢾⢮⢜⢼⣊⣎⣴⣚⣺⣪⡔⡦⡶⠰⡰⢐⠂⠆⠒⠲⠢⠖⠶⠦⠔⠴⠊⠎⠚⠺⠪⠞⠾⠮⠜⠼⡊⡎⡴⡚⡺⡪⣔⣦⣶⢰";

    static final String braille8Unicode_1 = " a1b'k2l@cif/msp\"e3h9o6r^djg>ntq,*5<-u8v.%[$+x!&;,4\\0z7(_?w]#y)=ABKL`CIFMSPEHOR~DJGNTQUV{X|ZW}Y";
    static final String braille8Unicode_2 = " ⠂⠄⠆⠈⠊⠌⠎⠐⠒⠔⠖⠘⠚⠜⠞⠠⠢⠤⠦⠨⠪⠬⠮⠰⠲⠴⠶⠸⠺⠼⠾⡀⡂⡄⡆⡈⡊⡌⡎⡐⡒⡔⡖⡘⡚⡜⡞⡠⡢⡤⡦⡨⡪⡬⡮⡰⡲⡴⡶⡸⡺⡼⡾⢂⢆⢊⢎⢐⢒⢔⢖⢚⢜⢞⢢⢦⢪⢮⢰⢲⢴⢶⢺⢼⢾⣊⣎⣔⣚⣦⣪⣴⣶⣺";

    // valable de 32 a 32+128 (faire char-32 pour mapper correctement)
    static final String fullAsciiToUnicode6_1 = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~";
    //static final String FULL_ASCII_TO_UNICODE_6_2 =       "⠀⠮⠐⠼⠫⠩⠯⠄⠷⠾⠡⠬⠠⠤⠨⠌⠴⠂⠆⠒⠲⠢⠖⠶⠦⠔⠱⠰⠣⠿⠜⠹⠈⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏⠟⠗⠎⠞⠥⠧⠺⠭⠽⠵⠪⠳⠻⠘⠸⠀⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏⠟⠗⠎⠞⠥⠧⠺⠭⠽⠵⠀⠀⠀⠀⠀";
    // Variante avec les Chiffres « Antoine » cf wikipedia (systeme recomandé)
    static final String FULL_ASCII_TO_UNICODE_6_ANTOINE = "⠀⠮⠐⠼⠫⠩⠯⠄⠷⠾⠡⠬⠠⠤⠨⠌⠼⠡⠣⠩⠹⠱⠫⠻⠳⠪⠱⠰⠣⠿⠜⠹⠈⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏⠟⠗⠎⠞⠥⠧⠺⠭⠽⠵⠪⠳⠻⠘⠸⠀⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏⠟⠗⠎⠞⠥⠧⠺⠭⠽⠵⠀⠀⠀⠀⠀";
    static final String defaultFullAsciiToUnicode = FULL_ASCII_TO_UNICODE_6_ANTOINE;

    public static SortedMap<Character, Character> mapAsciiToUnicodeBraille = new TreeMap();
    public static SortedMap<Character, Character> mapUnicodeBrailleToAscii = new TreeMap();

    static {
        initAsciiBrailleConverter();
    }

    // TODO a utiliser pour faire des mouse over intelligents
    static class WordElt {

        EType type;
        int posTxt,
                posBraille;
        String txt, braille;

        WordElt(EType type, int posTxt, String txt) {
            this.type = type;
            this.posTxt = posTxt;
            this.txt = txt;
        }

        public String toBraille() {
            if (braille == null) {
                switch (type) {
                    case MIX_CHAR:
                        braille = mixToBraille(txt);
                        break;
                    case DIGIT:
                        braille = digitsToBraille(txt);
                        break;
                    case UPPER:
                        braille = uppersToBraille(txt);
                        break;
                    case UPPER_SEQ_FIRST:
                        braille = CH_MAJ_SEQ + simpleToBraille(txt);
                        break;
                    case UPPER_SEQ_LAST:
                        braille = CH_MAJ + simpleToBraille(txt);
                        break;
                    case UPPER_SEQ:
                    case SIMPLE:
                    case PUNCTUATION:
                    default:
                        braille = simpleToBraille(txt);
                        break;
                }
            }
            return braille;
        }

        public void setType(EType type) {
            if (type != this.type) {
                this.braille = null;
                this.type = type;
            }
        }

        private void setPosInBraille(int pos) {
            posBraille = pos;
        }

    }

// TODO    
// http://braillelog.net/majuscules-et-mises-en-evidence.php
// Si une suite d'au moins quatre mots est en majuscule, on l'indique en plaçant, 
// devant le premier mot de cette suite, le symbole constitué du caractère "deux-points" (combinaison 2 5) suivi du signe de majuscule. 
// La fin de cette séquence en majuscule se matérialise par la présence d'un seul signe de majuscule devant son dernier mot.
    public static String digitsToBraille(String word) {
        return CH_NUM + simpleToBraille(word);
    }

    public static String uppersToBraille(String word) {
        return (word.length() > 1 ? CH_MAJ + CH_MAJ : CH_MAJ) + simpleToBraille(word);
    }

    public static String mixToBraille(String word) {
        String braille = "";
        for (char ch : word.toCharArray()) {
            int id = ch - 32;
            if (Character.isUpperCase(ch)) {
                braille += CH_MAJ;
            }
            braille += (id >= 0 && id < defaultFullAsciiToUnicode.length()) ? defaultFullAsciiToUnicode.charAt(id) : '?';
        }
        return braille;
    }

    public static String simpleToBraille(String word) {
        String braille = "";
        for (char ch : word.toCharArray()) {
            if (ch == '\n' || ch == '\r' || ch == '\t') {
                braille += ch;
            } else {
                int id = ch - 32;
                braille += (id >= 0 && id < defaultFullAsciiToUnicode.length()) ? defaultFullAsciiToUnicode.charAt(id) : '?';
            }
        }
        return braille;
    }

    public static class WordEncoder {

        List<WordElt> lstElt = new ArrayList<>();

        protected String toBraille(String txt) {
            lstElt.clear();

            WordElt elt;
            List<WordElt> upperSequence = new ArrayList();

            String regex = "([^\\d\\W]*)(\\d*)(\\W*)";
            Pattern p = Pattern.compile(regex);
            //  String source = "1234567890, 12345,  and  9876543210";
            String txtWithoutAccent = Normalizer.normalize(txt, Normalizer.Form.NFD);
            txtWithoutAccent = txtWithoutAccent.replaceAll("[^\\p{ASCII}]", "");
            // For unicode
            //  txtWithoutAccent = txtWithoutAccent.replaceAll("\\p{M}", "");
            Matcher m = p.matcher(txtWithoutAccent);

            while (m.find()) {
                String word = m.group(1);
                String digits = m.group(2);
                String nonAscii = m.group(3);

                if (word != null && !word.isEmpty()) {
                    int nbUpper = 0;

                    for (char ch : word.toCharArray()) {
                        if (Character.isUpperCase(ch)) {
                            nbUpper++;
                        }
                    }
                    EType type;
                    if (nbUpper == word.length()) {
                        type = EType.UPPER;
                    } else {
                        endUpperSequence(upperSequence);
                        type = nbUpper == 0 ? EType.SIMPLE : EType.MIX_CHAR;
                    }
                    elt = new WordElt(type, m.start(1), word);
                    if (type.equals(EType.UPPER)) {
                        upperSequence.add(elt);
                    }
                    lstElt.add(elt);
                }

                if (digits != null && !digits.isEmpty()) {
                    endUpperSequence(upperSequence);
                    elt = new WordElt(EType.DIGIT, m.start(2), digits);
                    lstElt.add(elt);
                }

                if (nonAscii != null && !nonAscii.isEmpty()) {
                    if (nonAscii.contains("\n")) {
                        endUpperSequence(upperSequence);
                    }
                    elt = new WordElt(EType.PUNCTUATION, m.start(2), nonAscii);
                    lstElt.add(elt);
                }
            }

            // }            
            String sTranslated = "";
            for (WordElt e : lstElt) {
                sTranslated += e.toBraille();
                e.setPosInBraille(sTranslated.length());
            }
            return sTranslated;
        }

        private void endUpperSequence(List<WordElt> upperSequence) {
            if (upperSequence.size() >= 4) {
                upperSequence.get(0).setType(EType.UPPER_SEQ_FIRST);
                for (int i = 1; i < upperSequence.size() - 1; i++) {
                    upperSequence.get(i).setType(EType.UPPER_SEQ);
                }
                upperSequence.get(upperSequence.size() - 1).setType(EType.UPPER_SEQ_LAST);
            }
            // La sequence majuscule est terminee
            upperSequence.clear();
        }
    }

    static String toBraille(String txt) {
        WordEncoder encoder = new WordEncoder();
        String braille = encoder.toBraille(txt);
        return braille;
    }

    void put(char ascii, int... dots) {
        char unicode = 0x2800;
        for (int c : dots) {
            unicode += 1 << c;
        }
        mapAsciiToUnicodeBraille.put(ascii, unicode);
        mapUnicodeBrailleToAscii.put(unicode, ascii);
    }

    void put(String ascii, String unicode) {
        for (int i = 0; i < ascii.length(); i++) {
            mapAsciiToUnicodeBraille.put(ascii.charAt(i), unicode.charAt(i));
            mapUnicodeBrailleToAscii.put(unicode.charAt(i), ascii.charAt(i));
        }
    }

    void printAll() {
        String ascii = "";
        String unicode = "";
        for (char c : mapAsciiToUnicodeBraille.keySet()) {
            ascii += c;
        }
        for (char c : mapAsciiToUnicodeBraille.values()) {
            unicode += c;
        }
        System.out.println(ascii);
        System.out.println(unicode);

        ascii = "";
        unicode = "";
        for (char c : mapUnicodeBrailleToAscii.keySet()) {
            ascii += c;
        }
        for (char c : mapUnicodeBrailleToAscii.values()) {
            unicode += c;
        }

        System.out.println(ascii);
        System.out.println(unicode);

        ascii = "";
        unicode = "";
        for (char c = 32; c < 128; c++) {
            ascii += c >= 'a' && c <= 'z' ? (char) (c - ('a' - 'A')) : c;
        }
        for (char c = 32; c < 128; c++) {
            Character un = mapAsciiToUnicodeBraille.get(c >= 'a' && c <= 'z' ? (char) (c - ('a' - 'A')) : c);
            unicode += un == null ? EMPTY : un;
        }

        System.out.println("Full ascii map");
        System.out.println(ascii);
        System.out.println(unicode);
    }

//AsciiBrailleConverter m = new AsciiBrailleConverter();
    static void initAsciiBrailleConverter() {
        AsciiBrailleConverter m = new AsciiBrailleConverter();
        m.put(asciiToBraille6_1, asciiToBraille6_2);
        m.printAll();
    }

    public static List<List<List<Character>>> getBrailleArray(String txt, int maxCharsByLine, int maxLinesByPage) {
        List<List<List<Character>>> chPages = new ArrayList();
        List<List<Character>> chPage;
        List<Character> chLine;

        final String[] pages = txt.split("\\f");

        for (String page : pages) {
            // pagesLinesChars
            chPage = new ArrayList();
            chPages.add(chPage);

            final String[] lines = page.split("\\r?\\n");
            for (String line : lines) {
                if (chPage.size() > maxLinesByPage) { // Trop de lignes on ajoute une page
                    chPage = new ArrayList();
                    chPages.add(chPage);
                }

                chLine = new ArrayList();
                chPage.add(chLine);

                for (int i = 0; i < line.length(); i++) { // TODO faire une ligne sur deux en sens inverse
                    char ch = line.charAt(i);
                    if (ch == '\t') {
                        if (chLine.size() < maxCharsByLine) {
                            chLine.add(EMPTY);
                        }
                        if (chLine.size() < maxCharsByLine) {
                            chLine.add(EMPTY);
                        }
                        if (chLine.size() < maxCharsByLine) {
                            chLine.add(EMPTY);
                        }
                    } else if (ch >= 0x2800 && ch <= 0x28FF) { // Deja de l'unicode Braille 
                        chLine.add(ch);
                    } else if (ch >= 32 && ch < 127) { // ASCII
                        Character unicode = defaultFullAsciiToUnicode.charAt(ch - 32);
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

}
