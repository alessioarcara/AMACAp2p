package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;

public class DecryptingService extends JavaService {

    public String RSA(BigInteger [] m){
        
        BigInteger [] mm = m;
        mm[0] = mm[0].modPow(mm[2], mm[1]);

        String decrypted_message = new String(mm[0].toByteArray());

        return decrypted_message;
    }

    public Value DecryptedMessage( Value request ) {

        //input
        BigInteger [] ChiaviPlusMessage = new BigInteger[3];
        ChiaviPlusMessage[0] = new BigInteger(request.getFirstChild( "message" ).strValue());
        ChiaviPlusMessage[1] = new BigInteger(request.getFirstChild( "publickey1" ).strValue());
        ChiaviPlusMessage[2] = new BigInteger(request.getFirstChild( "privatekey" ).strValue());

        //output
        Value response = Value.create();
        response.getFirstChild( "message" ).setValue(RSA(ChiaviPlusMessage));
        return response;
    }
}
