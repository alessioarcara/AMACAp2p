include "ServerInterface.iol"
include "file.iol"
include "console.iol"
include "DecryptingServiceInterface.iol"
include "KeyGeneratorServiceInterface.iol"

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

embedded {
  Java:
    "prova.KeyGeneratorService" in KeyGeneratorServiceOutputPort,
    "prova.DecryptingService" in DecryptingServiceOutputPort,
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
}