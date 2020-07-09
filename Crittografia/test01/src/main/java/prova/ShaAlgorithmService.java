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

    //6 funzioni logiche che operano su parole da 64 bit, che sono rappresentate da
    //x, y, z. Il risultato di ognuna di queste funzioni è una parola a 64 bit.
    
    // CH( x, y, z) = (x AND y) XOR ( (NOT x) AND z)
    // public String CH_function(String x, String y, String z){

    //     BigInteger bx = new BigInteger(x, 2);
    //     BigInteger by = new BigInteger(y, 2);
    //     BigInteger bz = new BigInteger(z, 2);

    //     return ((bx.and(by)).xor((bx.not()).and(bz))).toString();
    // }

    // MAJ( x, y, z) = (x AND y) XOR (x AND z) XOR (y AND z)
    // public String MAJ_function(String x, String y, String z){

    //     BigInteger bx = new BigInteger(x, 2);
    //     BigInteger by = new BigInteger(y, 2);
    //     BigInteger bz = new BigInteger(z, 2);

    //     return (bx.and(by).xor(bx.and(bz)).xor(by.and(bz))).toString();
    // }

    // //BSIG0(x) = ROTR^28(x) XOR ROTR^34(x) XOR ROTR^39(x)
    // public String BSIG0(String x){
        
    //     BigInteger x = new BigInteger(x);
        
    //     return (((x.shiftRight(28)).xor(x.shiftRight(34))).xor(x.shiftRight(39)).toString());

    // }
    // //BSIG1(x) = ROTR^14(x) XOR ROTR^18(x) XOR ROTR^41(x)
    // public String BSIG1(String x){

    //     BigInteger x = new BigInteger(x);
        
    //     return (((x.shiftRight(14)).xor(x.shiftRight(18))).xor(x.shiftRight(41)).toString());
        
    // }
    // //SSIG0(x) = ROTR^1(x) XOR ROTR^8(x) XOR SHR^7(x)
    // public String SSIG0(String x){

    //     BigInteger x = new BigInteger(x);
        
    //     return (((x.shiftRight(1)).xor(x.shiftRight(8))).xor(x.shiftRight(39)).toString());
        
    // }
    // //SSIG1(x) = ROTR^19(x) XOR ROTR^61(x) XOR SHR^6(x)
    // public String SSIG1(String x){

    //     BigInteger x = new BigInteger(x);
        
    //     return (((x.shiftRight(19)).xor(x.shiftRight(61))).xor(x.shiftRight(39)).toString());
        
    // }

    // con messaggio L < 2^128
    //  "1" viene appeso al messaggio.
    //  k "0" vengono appesi per soddisfare l'equazione:
    // L+1+K = 896 (mod 1024)
    // viene appeso un blocco da 128 bit della lunghezza di L
    // dopo questi passaggi la lunghezza della stringa sarà un multiplo di 1024 bit

    // public String Padding(String m){

    //     String s = m;

    //     byte[] bytes = s.getBytes();

    //     String finalString = "";
        
    //     for(int i = 0;i<bytes.length;i++){
                
    //         int tempChar =  Integer.parseInt(Byte.toString(bytes[i]));
    //         finalString = finalString + Integer.toBinaryString(tempChar);
                
    //     }

    //     finalString = finalString + 1;
    //     System.out.println("Stringa in binario con 1 appeso: " );
    //     System.out.println(finalString);

    //     int k = 0;

    //     while(finalString.length()+1+k < (896 % 1024)){
    //         finalString = finalString + 0;
    //         k++;
    //     }

    //     System.out.println("Stringa con tanti 0 = 896 % 1024: ");
    //     System.out.println(finalString);

    //     String Lmessage = Integer.toBinaryString(finalString.length());
    //     System.out.println(Lmessage);
    //     while(Lmessage.length() < 128){
    //         Lmessage = 0 + Lmessage;
    //     }
            
    //     finalString = finalString + Lmessage;
    //     System.out.println("messaggio finale: ");
    //     System.out.println(finalString);

    //     System.out.println("lunghezza messaggio padded:");
    //     System.out.println(finalString.length());

    //     return finalString;

    // }

    public Value ShaPreprocessingMessage( Value request ) {

        //input
        String s = request.getFirstChild( "message" ).strValue();

        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            byte[] data = md.digest(s.getBytes());
            StringBuilder sb = new StringBuilder();
            for(int i=0;i<data.length;i++){
                sb.append(Integer.toString((data[i] & 0xff) + 0x100, 16).substring(1));
            }
            System.out.println(sb);
        } catch(Exception e) {
            System.out.println(e); 
        }

        
        
        //output
        Value response = Value.create();
        response.getFirstChild("message").setValue(request.getFirstChild( "message" ).strValue());
        // response.getFirstChild( "message" ).setValue(RSA(ChiaviPlusMessage).toString());
        return response;
    }

}