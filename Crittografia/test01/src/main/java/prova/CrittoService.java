package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;

public class CrittoService extends JavaService {

    public BigInteger Euclide(BigInteger toziente){

        BigInteger t = toziente;
        BigInteger e = BigInteger.valueOf(2);
        BigInteger r = new BigInteger("0");

        //il massimo comune divisore di un coprimo con F(n) è 1; esco solo quando lo trovo
        while(r != BigInteger.valueOf(1)){

            r = e.gcd(t);
            System.out.println("resto: " + r);

            if(r == BigInteger.valueOf(1) ) {
                break;
            }

            e.add(BigInteger.valueOf(1));
            System.out.println("contatore: " + e);
        }
        return e;

    }

    public BigInteger RSA(byte [] s){

        //generazione due numeri primi attraverso libreria BigInteger di Java.Math
        BigInteger p;
        BigInteger q;
        BigInteger n;
        BigInteger toziente;
        //sistemare questo;
        BigInteger uno = BigInteger.valueOf(1);

        int lengthRSA = 2048;

        Random random = new Random();

        p = BigInteger.probablePrime(lengthRSA, random);
        //controllo per evitare che p e q siano identici anche se è remota la possibilità
        q = BigInteger.probablePrime(lengthRSA, random);

        n = p.multiply(q);
        toziente = (p.subtract(uno)).multiply(q.subtract(uno));

        Euclide(toziente);

        System.out.println(n);

        return p;
    }

    public Value encrypting( Value request ) {

        String message = request.getFirstChild( "message" ).strValue();
        System.out.println("Il messaggio inserito è: " + message );
        byte[] byteArr = message.getBytes();
        System.out.println("Il messaggio in bytes è: " + Arrays.toString(byteArr));
        RSA(byteArr);
        Value response = Value.create();
        response.getFirstChild( "reply" ).setValue(new String(byteArr));
        return response;
    }
}

