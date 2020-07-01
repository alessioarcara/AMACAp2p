package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;

public class CrittoService extends JavaService {

    // Problema: il ciphertext generato dall'algoritmo RSA è di lunghezza diverso per la diversa lunghezza del plaintext
    // Soluzione da trovare: generare ciphertext di lunghezza standard

    public BigInteger Euclide(BigInteger toziente){

        System.out.println("");
        System.out.println("** inizializzazione algoritmo di Euclide **");

        BigInteger t = toziente;
        BigInteger e = BigInteger.valueOf(2);
        BigInteger r = new BigInteger("0");

        //il massimo comune divisore di un coprimo con F(n) è 1; esco solo quando lo trovo
        while(!(r.equals(BigInteger.ONE))){

            r = e.gcd(t);
            System.out.println("resto: " + r);

            if(r.equals(BigInteger.ONE)){
                break;
            }

            e = e.add(BigInteger.ONE);
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
        BigInteger uno = BigInteger.ONE;
        BigInteger e;
        BigInteger c;

        BigInteger m;
        byte [] ms = s;
        System.out.println(Arrays.toString(ms));

        int lengthRSA = 1024;

        Random random = new Random();

        p = BigInteger.probablePrime(lengthRSA, random);
        //controllo per evitare che p e q siano identici anche se è remota la possibilità
        q = BigInteger.probablePrime(lengthRSA, random);

        n = p.multiply(q);
        toziente = (p.subtract(uno)).multiply(q.subtract(uno));

        e = Euclide(toziente);

        //cifratura per singola cifra o intero messaggio? 
        m = new BigInteger(s);

        //ottimizzare cifratura con aritmetica modulo
        c = m.modPow(e, n);

        return c;
    }

    public Value encrypting( Value request ) {

        String message = request.getFirstChild( "message" ).strValue();
        System.out.println("Il messaggio inserito è: " + message );
        byte[] byteArr = message.getBytes();
        System.out.println("Il messaggio in bytes è: " + Arrays.toString(byteArr));

        Value response = Value.create();
        String messaggioCriptato = RSA(byteArr).toString();
        response.getFirstChild( "reply" ).setValue(messaggioCriptato);
        return response;
    }
}

