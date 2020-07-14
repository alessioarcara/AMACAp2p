package blend;

import javax.swing.*;
import javax.swing.plaf.basic.BasicOptionPaneUI.ButtonActionListener;
import java.awt.event.*;
import java.awt.*;

public class buttonListener implements ActionListener {
    
    public void actionPerformed( ActionEvent evt ) {
        String comando = evt.getActionCommand();

        if ( comando.equals("ESCI") ) {
            System.exit(0);
        } else
            if( comando.equals( "CHAT PRIVATA" ) ) {
                System.out.println( "CHAT PRIVATA" );
            } else
                if( comando.equals( "CHAT PUBBLICA" ) ) {
                    System.out.println( "CHAT PUBBLICA" );
                }
    }
}