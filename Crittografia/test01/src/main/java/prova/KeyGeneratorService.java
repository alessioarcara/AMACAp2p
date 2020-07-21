package prova;

import jolie.runtime.JavaService;
import jolie.runtime.Value;
import java.io.*;
import java.util.*;
import java.math.BigInteger;
import java.security.SecureRandom;


public class KeyGeneratorService extends JavaService {

    private BigInteger Euclide(BigInteger toziente){

        BigInteger t = toziente;
        BigInteger e = BigInteger.valueOf(2);
        BigInteger r = new BigInteger("0");

        //il massimo comune divisore di un coprimo con F(n) è 1; esco solo quando lo trovo
        while(!(r.equals(BigInteger.ONE))){

            r = e.gcd(t);

            if(r.equals(BigInteger.ONE)){
                break;
            }

            e = e.add(BigInteger.ONE);
        }
        return e;

    }

    public Value GenerazioneChiavi(){

        //inizializzazione variabili BigInteger
        BigInteger p;
        BigInteger q;
        BigInteger n;
        BigInteger toziente;
        BigInteger e;
        BigInteger d;

        int lengthRSA = 1024;

        SecureRandom random = new SecureRandom();
        p = BigInteger.probablePrime(lengthRSA, random);

        //controllo per evitare p e q identici
        do {
            q = BigInteger.probablePrime(lengthRSA, random);
        } while ( p.equals( q ));

        //prima chiave pubblica
        n = p.multiply(q);
        toziente = (p.subtract(BigInteger.ONE)).multiply(q.subtract(BigInteger.ONE));

        //seconda chiave pubblica
        e = Euclide(toziente);
        // 65537 = 2^16 + 1;
        // e = BigInteger.valueOf(65537);

        //chiave privata
        d = e.modPow(new BigInteger("-1"), toziente);

        //output
        Value response = Value.create();
        response.getFirstChild( "publickey1" ).setValue(n.toString());
        response.getFirstChild( "publickey2" ).setValue(e.toString());
        response.getFirstChild( "privatekey" ).setValue(d.toString());
        return response;
    }
}

