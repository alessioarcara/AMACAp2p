package blend;

import javax.swing.*;
import javax.swing.plaf.basic.BasicOptionPaneUI.ButtonActionListener;
import java.awt.event.*;
import java.awt.*;
import java.sql.Timestamp;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import jolie.runtime.embedding.RequestResponse;

public class JavaSwingConsole extends JavaService {

    public static void aperturaMenu() {
   
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

    private JFrame frame = new JFrame();
    private JTextArea textArea;
    private JScrollPane scrollPane;
    private final static String newline = "\n";
    private Timestamp timestamp;

    public void aperturaConsole() {

        //CREAZIONE FRAME
        frame = new JFrame();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(400,400);

        //CREAZIONE TEXT AREA
        textArea = new JTextArea(5, 20);

        scrollPane = new JScrollPane(textArea); 
        textArea.setEditable(false);

        //AGGIUNTA TEXT AREA A FRAME
        frame.add(scrollPane);

        // frame.pack();   
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }

    public void modificaConsole(Value request){
    
        String text = request.strValue();
        timestamp = new Timestamp(System.currentTimeMillis());
        textArea.append(text + " (" + timestamp + ") "+ newline);

    }
}