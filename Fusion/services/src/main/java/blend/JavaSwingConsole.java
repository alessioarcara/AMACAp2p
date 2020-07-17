package blend;

import javax.swing.*;
import java.awt.event.*;
import java.awt.*;
import java.sql.Timestamp;

import jolie.runtime.JavaService;
import jolie.runtime.Value;

import java.util.Calendar;
import java.text.SimpleDateFormat;

public class JavaSwingConsole extends JavaService {

    //DICHIARAZIONE .
    private JFrame frame;
    private textAreaWithImage textArea;
    private JScrollPane scrollPane;
    private final static String newline = "\n";

    private buttonListener requestJolie;

    public void aperturaMenu( Value request ) {
        //RACCOLGO LA STRINGA IN INPUT .
        String stringa = request.strValue();

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

        requestJolie.contattaJolie();

        BoxLayout buttonPanel =  new BoxLayout( frame.getContentPane(), BoxLayout.Y_AXIS );

        frame.setLayout( buttonPanel );

        //AGGIUNTA STRINGA .
        JTextArea textArea;
        textArea = new JTextArea( stringa );

        //SETTAGGIO TEXTAREA .
        textArea.setAlignmentX( Component.CENTER_ALIGNMENT );
        textArea.setEditable( false );
        
        //AGGIUNTA TEXTAREA AL FRAME .
        frame.add( textArea );

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
        frame.setSize( 600, 400 );
        frame.setResizable( false );

        //SETTAGGIO NOME CONSOLE .
        frame.setTitle( "CONSOLE DI TRACCIAMENTO" );
        
        //CREAZIONE TEXT AREA DELLA CLASSE textAreaWithImage E SETTAGGI .
        textArea = new textAreaWithImage( 5, 20 );
        textArea.setBackground( new Color(1,1,1, ( float ) 0.01) );
        textArea.setEditable( false );
        
        //SETTAGGIO FONT E COLORE TESTO SU TEXTAREA .
        Font font = new Font( "Arial", Font.BOLD, 14 );
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
    
        //RICEZIONE TESTO .
        String text = request.strValue();

        //ISTANZA DI CALENDAR .
        Calendar calendario = Calendar.getInstance();
 
        //SETTAGGIO DATA CON GIORNO, MESE E ANNO .
        SimpleDateFormat data = new SimpleDateFormat("dd/MM/yyyy");

        //SETTAGGIO ORA .
        SimpleDateFormat ora = new SimpleDateFormat("HH:mm:ss");
        
        //VISUALIZZAZIONE MESSAGGIO SU CONSOLE .
        textArea.append( "(" + data.format( calendario.getTime() ) + ", " + ora.format( calendario.getTime() ) + ") - " + text + newline );
    }
}