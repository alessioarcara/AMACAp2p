include "ServerInterface.iol"
include "file.iol"
include "console.iol"
include "DecryptingServiceInterface.iol"
include "KeyGeneratorServiceInterface.iol"
include "ShaAlgorithmServiceInterface.iol"

execution{ concurrent }

init {
    
    println@Console( "avvio client B in ricezione..." )(  )
    GenerazioneChiavi@KeyGeneratorServiceOutputPort(  )( returnChiavi )

    chiaviPubbliche.publickey1 = returnChiavi.publickey1
    chiaviPubbliche.publickey2 = returnChiavi.publickey2   
    chiavePrivata.privatekey = returnChiavi.privatekey

    scambioChiavi( chiaviPubbliche_A )( chiaviPubbliche )
    
}

inputPort B {
    Location: "socket://localhost:9000"
    Protocol: sodep
    Interfaces: ServerInterface, scambioChiaviInterface
}

outputPort KeyGeneratorServiceOutputPort {
  Interfaces: KeyGeneratorServiceInterface
}

outputPort DecryptingServiceOutputPort {
    Interfaces: DecryptingServiceInterface
}

outputPort ShaAlgorithmServiceOutputPort {
    Interfaces: ShaAlgorithmServiceInterface
}

embedded {
  Java:
    "prova.KeyGeneratorService" in KeyGeneratorServiceOutputPort,
    "prova.DecryptingService" in DecryptingServiceOutputPort,
    "prova.ShaAlgorithmService" in ShaAlgorithmServiceOutputPort,
}

constants {
    FILENAME = "received.txt"
}

main {

    [sendStringhe( request )( ) {

        //DECRIPTAZIONE
        request.publickey1 = chiaviPubbliche.publickey1
        request.pub_priv_key = chiavePrivata.privatekey
        request.cripto_bit = 1

        Decodifica_RSA@DecryptingServiceOutputPort( request )( response );
        println@Console( "il messaggio decriptato è: " ) (  )
        println@Console( response.message )(  )

        with( rq_w ) {
            .filename = FILENAME;
            .content = response.message + "\n";
            .append = 1
        }
        
        writeFile@File( rq_w )()

    }]

    [sendStringhePubblico( firma )( ) {

        //DECRIPTAZIONE FIRMA DIGITALE:

        //decripto l'hash del messaggio
        plaintext.message = firma.plaintext
        firma.pub_priv_key = firma.publickey2
        undef ( firma.publickey2 )
        undef ( firma.plaintext )
        firma.cripto_bit = 0
        Decodifica_RSA@DecryptingServiceOutputPort( firma )( firma_decodificata )

        //genero l'hash del messaggio ricevuto
        ShaPreprocessingMessage@ShaAlgorithmServiceOutputPort ( plaintext ) ( hash_plaintext )

        //confronto l'hash generato con l'hash ricevuto
        if(hash_plaintext.message == firma_decodificata.message) {
            println@Console( "Messaggio integro." ) (  )
            println@Console( "Il messaggio inviato è: " ) (  )
            println@Console( plaintext.message ) (  )
            println@Console( "" )(  )
        } else {
            println@Console( "Messaggio corrotto." ) (  )
        }
        
        with( rq_w ) {
            .filename = FILENAME;
            .content = plaintext.message + " (*messaggio integro*) " + "\n";
            .append = 1
        }
        
        writeFile@File( rq_w )()

    }]
}