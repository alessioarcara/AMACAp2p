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
        request.privatekey = chiavePrivata.privatekey

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
        Decodifica_SHA@DecryptingServiceOutputPort( firma )( firma_decodificata )

        //genero l'hash del messaggio ricevuto
        rigeneroHash.message = firma.plaintext
        ShaPreprocessingMessage@ShaAlgorithmServiceOutputPort ( rigeneroHash ) ( hashed_plaintext )

        //confronto l'hash generato con l'hash ricevuto
        if(hashed_plaintext.message == firma_decodificata.hashcriptato) {
            println@Console( "Messaggio integro." ) (  )
            println@Console( "Il messaggio inviato è: " ) (  )
            println@Console( firma.plaintext ) (  )
        } else {
            println@Console( "Messaggio corrotto." ) (  )
        }
        
        
        with( rq_w ) {

            .filename = FILENAME;
            .content = firma.plaintext + "messaggio integro\n";
            .append = 1

        }
        
        writeFile@File( rq_w )()

    }]
}