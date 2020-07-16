package blend;

import javax.swing.*;
import java.awt.event.*;
import java.awt.*;
import java.sql.Timestamp;

import jolie.runtime.JavaService;
import jolie.runtime.Value;

public class JavaSwingConsole extends JavaService {

    private JFrame frame;
    private textAreaWithImage textArea;
    private JScrollPane scrollPane;
    private final static String newline = "\n";
    private Timestamp timestamp;

    public void aperturaMenu() {

        //CREAZIONE ISTANZA FRAME .
        frame = new JFrame();
        
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
        frame.setDefaultCloseOperation( JFrame.EXIT_ON_CLOSE );
    }

    public void aperturaConsole() {

        //CREAZIONE ISTANZA FRAME .
        frame = new JFrame();

        //SETTAGGI FRAME .
        frame.setDefaultCloseOperation( JFrame.EXIT_ON_CLOSE );
        frame.setSize( 550, 400 );
        frame.setResizable( false );

        //SETTAGGIO NOME CONSOLE .
        frame.setTitle( "CONSOLE DI TRACCIAMENTO" );
        
        //CREAZIONE TEXT AREA DELLA CLASSE textAreaWithImage E SETTAGGI .
        textArea = new textAreaWithImage( 5, 20 );
        textArea.setBackground( new Color(1,1,1, ( float ) 0.01) );
        textArea.setEditable( false );
        
        //SETTAGGIO FONT E COLORE TESTO SU TEXTAREA .
        Font font = new Font( "Times New Roman", Font.BOLD, 14 );
        textArea.setFont( font );  //AGGIUNTA FONT A textArea .
        textArea.setForeground( Color.WHITE ); //Settaggio colore .

        //ISTANZA SCROLLPANE .
        scrollPane = new JScrollPane( textArea ); 

        //AGGIUNTA SCROLLPANE A FRAME
        frame.add( scrollPane );
  
        frame.setLocationRelativeTo( null );
        frame.setVisible( true );        
    }

    public void modificaConsole( Value request ){
    
        String text = request.strValue();
        timestamp = new Timestamp( System.currentTimeMillis() );
        textArea.append( text + " (" + timestamp + ") "+ newline );
    }
}