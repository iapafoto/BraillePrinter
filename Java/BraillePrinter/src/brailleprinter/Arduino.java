/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package brailleprinter;

import java.awt.Dimension;
import java.io.PrintWriter;
import java.util.Scanner;

import com.fazecast.jSerialComm.*;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

public class Arduino {

    public static interface DataListener {

        void onDataAvailable(byte[] data);
    }

    public static interface DataListenerString {

        void onDataAvailable(String data);
    }

    private SerialPort comPort;
    private String portDescription;
    private int baud_rate;
    private DataListener dataListener;

    public Arduino() {
        //empty constructor if port undecided
    }

    public Arduino(String portDescription) {
        //make sure to set baud rate after
        this.portDescription = portDescription;
        comPort = SerialPort.getCommPort(this.portDescription);

    }

    public Arduino(String portDescription, int baud_rate) {
        //preferred constructor
        this.portDescription = portDescription;
        comPort = SerialPort.getCommPort(this.portDescription);
        this.baud_rate = baud_rate;
        comPort.setBaudRate(this.baud_rate);
    }

    public void setDataListener(DataListener dataListener) {
        this.dataListener = dataListener;

        comPort.addDataListener(new SerialPortDataListener() {
            @Override
            public int getListeningEvents() {
                return SerialPort.LISTENING_EVENT_DATA_AVAILABLE; //To change body of generated methods, choose Tools | Templates.
            }

            @Override
            public void serialEvent(SerialPortEvent event) {
                if (event.getEventType() != SerialPort.LISTENING_EVENT_DATA_AVAILABLE) {
                    return;
                }

                byte[] newData = new byte[comPort.bytesAvailable()];
                int numRead = comPort.readBytes(newData, newData.length);
                //    System.out.println("Read " + numRead + " bytes."); //To change body of generated methods, choose Tools | Templates.
                // String out = new String(newData);
                dataListener.onDataAvailable(newData);
            }
        });
    }

    byte[] buffer = {};

    // renvoi le String dans le bon charset (detecte la fin grace au char de fin definit (doit etre sur 1 byte pour le moment))
    public void setDataListenerString(Charset charset, char end, DataListenerString dataListener) {
        setDataListener((byte[] data) -> {
            if (data.length > 0) {
                buffer = cat(buffer, data);
                if (data[data.length - 1] == end) {
                    dataListener.onDataAvailable(new String(buffer, charset));
                    buffer = new byte[0];
                }
            }
        });
    }

    public boolean openConnection() {
        if (comPort.openPort()) {
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
            }
            return true;
        } else {
            AlertBox alert = new AlertBox(new Dimension(400, 100), "Error Connecting", "Try Another port");
            alert.display();
            return false;
        }

    }

    public void closeConnection() {
        comPort.closePort();
    }

    public void setPortDescription(String portDescription) {
        this.portDescription = portDescription;
        comPort = SerialPort.getCommPort(this.portDescription);
    }

    public void setBaudRate(int baud_rate) {
        this.baud_rate = baud_rate;
        comPort.setBaudRate(this.baud_rate);
    }

    public String getPortDescription() {
        return portDescription;
    }

    public SerialPort getSerialPort() {
        return comPort;
    }

    public String serialRead() {
        //will be an infinite loop if incoming data is not bound
        comPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_SEMI_BLOCKING, 0, 0);
        String out = "";
        Scanner in = new Scanner(comPort.getInputStream());
        try {
            while (in.hasNext()) {
                out += (in.next() + "\n");
            }
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return out;
    }

    public String serialRead(int limit) {
        //in case of unlimited incoming data, set a limit for number of readings
        comPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_SEMI_BLOCKING, 0, 0);

        String out = "";
        int count = 0;
        Scanner in = new Scanner(comPort.getInputStream(), "UTF-8");
        try {
            while (in.hasNext() && count <= limit) {
                out += (in.next() + "\n");
                count++;
            }
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return out;
    }

    public void serialWrite(String s) {
        //writes the entire string at once.
        comPort.setComPortTimeouts(SerialPort.TIMEOUT_SCANNER, 0, 0);
        try {
            Thread.sleep(5);
        } catch (InterruptedException e) {
        }
        PrintWriter pout = new PrintWriter(comPort.getOutputStream());
        pout.print(s);
        pout.flush();
    }

    public void serialWrite(String s, int noOfChars, int delay) {
        //writes the entire string, 'noOfChars' characters at a time, with a delay of 'delay' between each send.
        comPort.setComPortTimeouts(SerialPort.TIMEOUT_SCANNER, 0, 0);
        try {
            Thread.sleep(5);
        } catch (Exception e) {
        }
        PrintWriter pout = new PrintWriter(comPort.getOutputStream());
        int i = 0;
        for (; i < s.length() - noOfChars; i += noOfChars) {
            pout.write(s.substring(i, i + noOfChars));
            pout.flush();
            try {
                Thread.sleep(delay);
            } catch (Exception e) {
            }
        }
        pout.write(s.substring(i));
        pout.flush();

    }

    public void serialWrite(char c) {
        //writes the character to output stream.
        comPort.setComPortTimeouts(SerialPort.TIMEOUT_SCANNER, 0, 0);
        try {
            Thread.sleep(5);
        } catch (Exception e) {
        }
        PrintWriter pout = new PrintWriter(comPort.getOutputStream());
        pout.write(c);
        pout.flush();
    }

    public void serialWrite(char c, int delay) {
        //writes the character followed by a delay of 'delay' milliseconds.
        comPort.setComPortTimeouts(SerialPort.TIMEOUT_SCANNER, 0, 0);
        try {
            Thread.sleep(5);
        } catch (InterruptedException e) {
        }
        PrintWriter pout = new PrintWriter(comPort.getOutputStream());
        pout.write(c);
        pout.flush();
        try {
            Thread.sleep(delay);
        } catch (InterruptedException e) {
        }
    }

    public static byte[] cat(byte[] buffer, byte[] data) {
        byte[] tmp = new byte[buffer.length + data.length];
        System.arraycopy(buffer, 0, tmp, 0, buffer.length);
        System.arraycopy(data, 0, tmp, buffer.length, data.length);
        return tmp;
    }

    
    
    
    public static void main(String[] args) {
        //String portname = Serial.list()[0]; // Mac OS X
        //String portname = "/dev/ttyUSB0"; // Linux
        //String portname = "COM6"; // Windows

        System.out.println("----------------------------------------");
        SerialPort[] lstPorts = SerialPort.getCommPorts();
        for (SerialPort port : lstPorts) {
            System.out.println(port.getDescriptivePortName());
        }
        System.out.println("----------------------------------------");

  //      Scanner ob = new Scanner(System.in);
        Arduino arduino = new Arduino("COM7", 9600); //enter the port name here, and ensure that Arduino is connected, otherwise exception will be thrown.
        arduino.openConnection();

        //System.out.println("Enter 1 to switch LED on and 0  to switch LED off");
        arduino.setDataListenerString(StandardCharsets.UTF_8, '\n', (String str) -> {
            System.out.print(str);
        });

        try {
            File fileDir = new File("C:\\Users\\durands\\Desktop\\FabLab\\texte-txt_nat.txt");

            BufferedReader in = new BufferedReader(
                    new InputStreamReader(new FileInputStream(fileDir), "UTF8"));
            String str;
            while ((str = in.readLine()) != null) {
//                System.out.println(str);
                arduino.serialWrite(str);
            }
            in.close();
        } catch (UnsupportedEncodingException e) {
            System.out.println(e.getMessage());
        } catch (IOException e) {
            System.out.println(e.getMessage());
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        
        arduino.closeConnection ();
    }


   



}
