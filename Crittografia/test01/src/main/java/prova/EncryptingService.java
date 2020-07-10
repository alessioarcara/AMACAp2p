package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;
import java.security.*;

public class EncryptingService extends JavaService {

    private String ByteArrayToBinaryString(byte[] bytes){
        
        String finalString = "";

        for(int i = 0; i<bytes.length; i++){
            
            String tempBit =  String.format("%8s", Integer.toBinaryString(bytes[i] & 0xFF)).replace(' ', '0');;
            finalString = finalString + tempBit;
        }
        return finalString;
    }

    private String xor_a_b(String s, String t) {

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

    private String Padding_SAEP(String s){

        MessageDigest md;
        SecureRandom random = new SecureRandom();

        byte[] bytes = s.getBytes();
        String m = ByteArrayToBinaryString(bytes);
        
        m = m.concat("1");
        while(m.length() < 512){
            m = m.concat("0");
        }

        byte seed[] = new byte[64];
        random.nextBytes(seed);
        String r = ByteArrayToBinaryString(seed);

        String g = "";
        try {
            md = MessageDigest.getInstance("SHA-512");
            byte[] data = md.digest(seed);
            g = ByteArrayToBinaryString(data);
        } 
        catch(Exception e) {
            System.out.println(e); 
        }

        m = xor_a_b(m, g).concat(r);
        return m;
    }

    public Value Codifica_RSA(Value request){

        BigInteger [] mc = new BigInteger[4];

        mc[0] = new BigInteger(Padding_SAEP(request.getFirstChild( "message" ).strValue()), 2);
        mc[1] = new BigInteger(request.getFirstChild( "publickey1" ).strValue());
        mc[2] = new BigInteger(request.getFirstChild( "publickey2" ).strValue());
        mc[3] = new BigInteger(request.getFirstChild( "privatekey" ).strValue());

        //c = m^e mod n
        mc[0] = mc[0].modPow(mc[2], mc[1]);

        //output
        Value response = Value.create();
        response.getFirstChild( "message" ).setValue(mc[0].toString());
        return response;
    }   
}

