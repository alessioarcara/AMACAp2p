package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;

public class EncryptingService extends JavaService {

    // Problema: il ciphertext generato dall'algoritmo RSA è di lunghezza diverso per la diversa lunghezza del plaintext
    // Soluzione da trovare: generare ciphertext di lunghezza standard -> padding

    public BigInteger RSA(BigInteger[] m){

        BigInteger [] mc = m;
        mc[0] = mc[0].modPow(mc[2], mc[1]);

        return mc[0];
    }

    public Value EncryptedMessage( Value request ) {

        //input
        BigInteger [] ChiaviPlusMessage = new BigInteger[4];
        ChiaviPlusMessage[0] = new BigInteger(request.getFirstChild( "message" ).strValue().getBytes());
        ChiaviPlusMessage[1] = new BigInteger(request.getFirstChild( "publickey1" ).strValue());
        ChiaviPlusMessage[2] = new BigInteger(request.getFirstChild( "publickey2" ).strValue());
        ChiaviPlusMessage[3] = new BigInteger(request.getFirstChild( "privatekey" ).strValue());
        
        //output
        Value response = Value.create();
        response.getFirstChild( "reply" ).setValue(RSA(ChiaviPlusMessage).toString());
        return response;
    }
}

