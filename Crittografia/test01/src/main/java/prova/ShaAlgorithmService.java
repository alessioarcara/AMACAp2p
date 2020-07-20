package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

//import java.lang.Integer.toBinaryString();

public class ShaAlgorithmService extends JavaService {

    private String ByteArrayToBinaryString(byte[] bytes){
        
        String finalString = "";

        for(int i = 0; i<bytes.length; i++){
            
            String tempBit =  String.format("%8s", Integer.toBinaryString(bytes[i] & 0xFF)).replace(' ', '0');;
            finalString = finalString + tempBit;
        }
        return finalString;
    }

    public Value ShaPreprocessingMessage( Value request ) {

        //input
        String s = request.getFirstChild( "message" ).strValue();
        String sb = "";

        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            byte[] data = md.digest(s.getBytes());
            sb = ByteArrayToBinaryString(data);
        } catch(Exception e) {
            System.out.println(e); 
        }
        
        //output
        Value response = Value.create();
        response.getFirstChild("message").setValue(sb);
        return response;
    }
}