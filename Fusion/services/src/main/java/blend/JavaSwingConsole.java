package blend;

import javax.swing.*;
import javax.swing.plaf.basic.BasicOptionPaneUI.ButtonActionListener;
import java.awt.event.*;
import java.awt.*;

import jolie.runtime.JavaService;
import jolie.runtime.embedding.RequestResponse;

public class JavaSwingConsole extends JavaService {

    public static void aperturaConsole() {
   
        //CREAZIONE FRAME .
        JFrame frame = new JFrame();

        //CREAZIONE BUTTON .
        JButton buttonChat = new JButton( "CHAT PRIVATA" );
        JButton buttonGroup = new JButton( "CHAT PUBBLICA" );
        JButton buttonExit = new JButton( "ESCI" );
        
        //SETTAGGIO BOTTONI .
        buttonChat.setAlignmentX( Component.CENTER_ALIGNMENT );
        buttonGroup.setAlignmentX( Component.CENTER_ALIGNMENT );
        buttonExit.setAlignmentX( Component.CENTER_ALIGNMENT );

        //GESTIONE EVENTI .
        ActionListener listener = new buttonListener();

        buttonExit.addActionListener( listener );
        buttonChat.addActionListener( listener );
        buttonGroup.addActionListener( listener );

        BoxLayout buttonPanel =  new BoxLayout( frame.getContentPane(), BoxLayout.Y_AXIS );

        frame.setLayout( buttonPanel );

        //AGGIUNTA BUTTON A FRAME .
        frame.add( buttonChat );
        frame.add( buttonGroup );
        frame.add( buttonExit );

        frame.pack();

        frame.setVisible( true );

        //CHIUSURA CONSOLE .
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
}