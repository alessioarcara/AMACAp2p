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

    public Integer aperturaMenu( Value request ) {

        //Acquisisco valore string in ingresso .
        String stringa = request.strValue();

        //Inizializzo una stringa di bottoni .
        String[] buttons = { "CHAT PRIVATA", "PARTECIPA", "EXIT", "CREA GRUPPO" };

        //RITORNO IL VALORE INTERO DA CONFRONTARE NEL PeerAA.ol .
        return JOptionPane.showOptionDialog(null, stringa, "SCEGLI ISTRUZIONE", JOptionPane.WARNING_MESSAGE, 0, new ImageIcon("services/src/main/java/blend/icoAmaca.jpg"), buttons, buttons[2]);

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
        textArea.setFont( font );  //AGGIUNTA FONT a textArea .
        textArea.setForeground( Color.WHITE ); //Settaggio colore .

        //ISTANZA SCROLLPANE .
        scrollPane = new JScrollPane( textArea ); 

        //AGGIUNTA SCROLLPANE A FRAME
        frame.add( scrollPane );
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
        textArea.append( "(" + data.format( calendario.getTime() ) + ", " + ora.format( calendario.getTime() ) + ") - " + text + "\n" );
    }
}