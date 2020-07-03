include "ServerInterface.iol"
include "file.iol"
include "console.iol"
include "DecryptingServiceInterface.iol"
include "KeyGeneratorServiceInterface.iol"

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

    restituzioneChiavi@KeyGeneratorServiceOutputPort(  )( returnChiavi );

    chiaviPubbliche.publickey1 = returnChiavi.publickey1;
    chiaviPubbliche.publickey2 = returnChiavi.publickey2;   
    println@Console( "chiave1"+chiaviPubbliche.publickey1 )(  )
    println@Console( "chiave2"+chiaviPubbliche.publickey2 )(  ) 

    chiavePrivata.privatekey = returnChiavi.privatekey;

    scambioChiavi( chiaviPubbliche_A )( chiaviPubbliche );

    sendStringhe( request )( "ÄCK" ) {

        // with( rq_w ) {

        //     response = "messaggio ricevuto"
        //     println@Console( "il messaggio criptato ricevuto è: " )(  )
        //     println@Console( request.message )(  )
        //     // println@Console( "La chiave pubblica è: " )(  )
        //     // println@Console( request.publickey )(  )
        //     .filename = FILENAME;
        //     .content = request + "\n";
        //     .append = 1

        // }
        
        // writeFile@File( rq_w )()

        //DECRIPTAZIONE
        request.publickey1 = chiaviPubbliche_A.publickey1
        request.privatekey = chiavePrivata.privatekey

        DecryptedMessage@DecryptingServiceOutputPort( request )( response );
        println@Console( "il messaggio decriptato è: " ) (  )
        println@Console( response.message )(  )

    }
}