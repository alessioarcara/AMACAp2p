package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;

public class DecryptingService extends JavaService {

    public Value DecryptedMessage( Value request ) {

        String message = request.getFirstChild( "message" ).strValue();
        System.out.println( message );
        Value response = Value.create();
        response.getFirstChild( "reply" ).setValue( "I am your father" );
        return response;
    }
}
