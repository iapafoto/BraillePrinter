package brailleprinter;

import com.fazecast.jSerialComm.*;
import javax.swing.*;

public class PortDropdownMenu extends JComboBox<String> {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void refreshMenu(){
		this.removeAllItems();
		SerialPort[] portNames = SerialPort.getCommPorts();
		for(int i = 0; i < portNames.length; i++)
			this.addItem(portNames[i].getSystemPortName());				
	}
}

	
