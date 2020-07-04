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

        System.out.println("siamo nel metodo encrypting:" + mc[0] + " elevato a " + mc[2] + " modulo " + mc[1]);
        mc[0] = mc[0].modPow(mc[2], mc[1]);

        return mc[0];
    }

    public Value EncryptedMessage( Value request ) {

        //input
        BigInteger [] ChiaviPlusMessage = new BigInteger[4];

        //trasformazione
        String s = request.getFirstChild( "message" ).strValue();
        byte[] bytes = s.getBytes();
        BigInteger message = new BigInteger(bytes);

        ChiaviPlusMessage[0] = message;
        System.out.println("il messaggio decriptato è: ");
        System.out.println(ChiaviPlusMessage[0]);
        ChiaviPlusMessage[1] = new BigInteger(request.getFirstChild( "publickey1" ).strValue());
        ChiaviPlusMessage[2] = new BigInteger(request.getFirstChild( "publickey2" ).strValue());
        ChiaviPlusMessage[3] = new BigInteger(request.getFirstChild( "privatekey" ).strValue());
        
        //output
        Value response = Value.create();
        response.getFirstChild( "message" ).setValue(RSA(ChiaviPlusMessage).toString());
        return response;
    }
}

