package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*; 
import java.util.*; 
import java.math.BigInteger;

public class KeyGeneratorService extends JavaService {

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
        System.out.println("");
        return e;

    }

    public String [] GenerazioneChiavi(){

        //inizializzazione variabili BigInteger
        BigInteger p;
        BigInteger q;
        BigInteger n;
        BigInteger toziente;
        BigInteger e;
        BigInteger d;

        int lengthRSA = 512;

        Random random = new Random();
        p = BigInteger.probablePrime(lengthRSA, random);
        //aggiungere controllo per evitare che p e q siano identici anche se è remota la possibilità
        q = BigInteger.probablePrime(lengthRSA, random);

        //prima chiave pubblica
        n = p.multiply(q);
        toziente = (p.subtract(BigInteger.ONE)).multiply(q.subtract(BigInteger.ONE));

        //seconda chiave pubblica
        e = Euclide(toziente);
        // e = BigInteger.valueOf(65537);

        //chiave privata
        // d = (e.pow(-1)).mod(toziente);
        d = e.modPow(new BigInteger("-1"), toziente);
        System.out.println("chiave privata :" + d);
        // d = e.modInverse(toziente);

        String s [] = new String[3];
        s[0] = n.toString();
        s[1] = e.toString();
        s[2] = d.toString();

        return s;
    }

    public Value restituzioneChiavi( Value request ) {

        //output
        Value response = Value.create();
        String [] chiavi = GenerazioneChiavi();
        response.getFirstChild( "publickey1" ).setValue(chiavi[0]);
        response.getFirstChild( "publickey2" ).setValue(chiavi[1]);
        response.getFirstChild( "privatekey" ).setValue(chiavi[2]);
        return response;
    }
}

