package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;
import java.security.*;

public class DecryptingService extends JavaService {

    private MessageDigest md;

    public String removePreliminaryPad(String s, int n){
        if(s.charAt( n - 1 ) == '0'){
            s = s.substring(0, n - 1);
        }
        else{
            s = s.substring(0, n - 1);
            return s;
        }
        return removePreliminaryPad(s, n - 1);
    }

    public String stringToBinaryString(byte[] bytes){
        
        String finalString = "";

        for(int i = 0; i<bytes.length; i++){
            
            String tempBit =  String.format("%8s", Integer.toBinaryString(bytes[i] & 0xFF)).replace(' ', '0');;
            finalString = finalString + tempBit;
        }
        return finalString;
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

    public byte [] binaryStringToByteArray(String s){
        
        byte[] b_byte = new byte[s.length()/8];
        int i=0;
        int j=0;
        while (i < s.length()){
            b_byte[j] = ((byte)Integer.parseInt((s.substring(i, i+8)), 2));
            j++;
            i+=8;
        }
        return b_byte;
    }

    public String binaryStringToText(String s){
        
        String text ="";
        for(int i = 0; i <= s.length() - 8; i+=8) {
        int k = Integer.parseInt(s.substring(i, i+8), 2);
        text += (char) k;
        }   
        return text;
    }

    public String unpad_SOAEP(String s){
        
        String messagePadded = s;

        String r = messagePadded.substring(512, messagePadded.length());
        String m = messagePadded.substring(0, 511);

        String g = "";

        try{
        md = MessageDigest.getInstance("SHA-512");
        byte[] data = binaryStringToByteArray(r);
        data = md.digest(data);
        g = stringToBinaryString(data);
        } catch(Exception e) {
            System.out.println(e); 
        }
        String mm = xor_a_b(m, g);
        return removePreliminaryPad(mm, mm.length());
    }

    private String RSA(BigInteger [] m){
        
        BigInteger [] mm = m;
        mm[0] = mm[0].modPow(mm[2], mm[1]);
        
        //controllo
        byte [] array = mm[0].toByteArray();
        if (array[0] == 0) {
            byte[] tmp = new byte[array.length - 1];
            System.arraycopy(array, 1, tmp, 0, tmp.length);
            array = tmp;
        }
        return stringToBinaryString(array);
    }

    public Value DecryptedMessage( Value request ) {

        //input
        BigInteger [] ChiaviPlusMessage = new BigInteger[3];
        ChiaviPlusMessage[0] = new BigInteger(request.getFirstChild( "message" ).strValue());
        ChiaviPlusMessage[1] = new BigInteger(request.getFirstChild( "publickey1" ).strValue());
        ChiaviPlusMessage[2] = new BigInteger(request.getFirstChild( "privatekey" ).strValue());
        
        //output
        Value response = Value.create();
        response.getFirstChild( "message" ).setValue(binaryStringToText(unpad_SOAEP(RSA(ChiaviPlusMessage))));
        return response;
    }
}
