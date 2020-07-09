package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;
import java.security.*;

public class EncryptingService extends JavaService {

    // SOAEP costanti
    private SecureRandom random = new SecureRandom();
    private MessageDigest md;

    public String stringToBinaryString(byte[] bytes){
        
        String finalString = "";

        for(int i = 0; i<bytes.length; i++){
            
            String tempBit =  String.format("%8s", Integer.toBinaryString(bytes[i] & 0xFF)).replace(' ', '0');;
            finalString = finalString + tempBit;
        }
        return finalString;
    }

    public String hexToBin(String s) {
        return new BigInteger(s, 16).toString(2);
    }

    public String xor_a_b(String s, String t) {

        String s_xor = "";
        for (int i=0; i < s.length(); i++){
            if(s.charAt(i) == t.charAt(i)){
                s_xor += "0";
            } else {
                s_xor += "1";
            }
        }

        return s_xor;
    }

    private String Pad_SOAEP(String s){

        String m = s;
        byte[] bytes = m.getBytes();
        m = stringToBinaryString(bytes);
        
        int x = 0;
        m = m.concat("1");
        while(m.length() < 512){
            m = m.concat("0");
            x++;
        }

        byte seed[] = new byte[64]; //512 bits in 64 bytes
        random.nextBytes(seed);
        String r = stringToBinaryString(seed);

        String g = "";
        try {
            md = MessageDigest.getInstance("SHA-512");
            byte[] data = md.digest(seed);
            g = stringToBinaryString(data);
        } 
        catch(Exception e) {
            System.out.println(e); 
        }

        String mm = xor_a_b(m, g);
        mm = mm.concat(r);
        return mm;
    }

    private BigInteger RSA(BigInteger[] m){

        BigInteger [] mc = m;
        mc[0] = mc[0].modPow(mc[2], mc[1]);

        return mc[0];
    }

    public Value EncryptedMessage( Value request ) {
        
        //input
        BigInteger [] ChiaviPlusMessage = new BigInteger[4];

        //trasformazione
        String s = request.getFirstChild( "message" ).strValue();
        byte[] bytes = s.getBytes();
        BigInteger message = new BigInteger(Pad_SOAEP(s), 2);

        ChiaviPlusMessage[0] = message;
        ChiaviPlusMessage[1] = new BigInteger(request.getFirstChild( "publickey1" ).strValue());
        ChiaviPlusMessage[2] = new BigInteger(request.getFirstChild( "publickey2" ).strValue());
        ChiaviPlusMessage[3] = new BigInteger(request.getFirstChild( "privatekey" ).strValue());
        
        //output
        Value response = Value.create();
        response.getFirstChild( "message" ).setValue(RSA(ChiaviPlusMessage).toString());
        return response;
    }
}

