package blend;

import java.awt.event.*;

import jolie.runtime.Value;

public class buttonListener implements ActionListener {

    private Value message = Value.create();  //Crea Value .
    
    public void actionPerformed( ActionEvent evt ) {
        String comando = evt.getActionCommand();

        if ( comando.equals("ESCI") ) {
            System.exit(0);
        } else
            if( comando.equals( "CHAT PRIVATA" ) ) {
                // System.out.println( "CHAT PRIVATA" );
                message.getFirstChild( "text" ).setValue( "CHAT".toString() );
            } else
                if( comando.equals( "CHAT PUBBLICA" ) ) {
                    System.out.println( "CHAT PUBBLICA" );
                }
    }

    public Value contattaJolie() {
        return message;
    }
}