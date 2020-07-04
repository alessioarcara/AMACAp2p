package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;
//import java.lang.Integer.toBinaryString();

public class ShaAlgorithmService extends JavaService {

    public Value ShaPreprocessingMessage( Value request ) {

        //trasformazione
        String s = request.getFirstChild( "message" ).strValue();
        // byte[] bytes = s.getBytes();

        // String[] binario = new binario[bytes.length];
        // for (i=0; i<bytes.length(); i++) {
        //     binario[i] = bytes[i].toBinaryString();
        // }
        

        
        //output
        Value response = Value.create();
        response.getFirstChild("message").setValue(request.getFirstChild( "message" ).strValue());
        // response.getFirstChild( "message" ).setValue(RSA(ChiaviPlusMessage).toString());
        return response;
    }

}