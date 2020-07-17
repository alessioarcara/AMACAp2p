package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;
import java.security.*;

public class DecryptingService extends JavaService {

    private String removePreliminaryPad(String s, int n){
        if(s.charAt( n - 1 ) == '0'){
            s = s.substring(0, n - 1);
        }
        else{
            s = s.substring(0, n - 1);
            return s;
        }
        return removePreliminaryPad(s, n - 1);
    }

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

    private byte [] binaryStringToByteArray(String s){
        
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

    private String binaryStringToText(String s){
        
        String text ="";
        for(int i = 0; i <= s.length() - 8; i+=8) {
            text += (char) Integer.parseInt(s.substring(i, i+8), 2);
        }   
        return text;
    }

    private String unpadding_SAEP(String s){

        MessageDigest md;

        String r = s.substring(512, s.length());
        String m = s.substring(0, 511);

        String g = "";

        try{
            md = MessageDigest.getInstance("SHA-512");
            byte[] data = binaryStringToByteArray(r);
            data = md.digest(data);
            g = ByteArrayToBinaryString(data);
        } catch(Exception e) {
            System.out.println(e); 
        }
        return removePreliminaryPad(xor_a_b(m, g), xor_a_b(m, g).length());
    }

    public Value Decodifica_RSA(Value request){
        
        //input
        BigInteger [] mm = new BigInteger[3];

        mm[0] = new BigInteger(request.getFirstChild( "message" ).strValue());
        mm[1] = new BigInteger(request.getFirstChild( "publickey1" ).strValue());
        mm[2] = new BigInteger(request.getFirstChild( "privatekey" ).strValue());

        // m = c^d mod n
        mm[0] = mm[0].modPow(mm[2], mm[1]);
        
        //controllo array[0] == 0
        byte [] array = mm[0].toByteArray();
        if (array[0] == 0) {
            byte[] tmp = new byte[array.length - 1];
            System.arraycopy(array, 1, tmp, 0, tmp.length);
            array = tmp;
        }

        //output
        Value response = Value.create();
        response.getFirstChild( "message" ).setValue(binaryStringToText(unpadding_SAEP(ByteArrayToBinaryString(array))));
        return response;
    }

    public Value Decodifica_SHA(Value request){
        
        //input
        BigInteger [] mm = new BigInteger[3];

        mm[0] = new BigInteger(request.getFirstChild( "hashcriptato" ).strValue());
        mm[1] = new BigInteger(request.getFirstChild( "publickey1" ).strValue());
        mm[2] = new BigInteger(request.getFirstChild( "publickey2" ).strValue());

        // m = c^e mod n
        mm[0] = mm[0].modPow(mm[2], mm[1]);
        
        //controllo array[0] == 0
        byte [] array = mm[0].toByteArray();
        if (array[0] == 0) {
            byte[] tmp = new byte[array.length - 1];
            System.arraycopy(array, 1, tmp, 0, tmp.length);
            array = tmp;
        }

        //output
        Value response = Value.create();
        response.getFirstChild( "hashcriptato" ).setValue(ByteArrayToBinaryString(array));
        return response;
    }
}
