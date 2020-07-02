include "ServerInterface.iol"
include "file.iol"
include "console.iol"
include "DecryptingServiceInterface.iol"

execution{ concurrent }

inputPort B {
    Location: "socket://localhost:9000"
    Protocol: sodep
    Interfaces: ServerInterface
}

outputPort DecryptingServiceOutputPort {
    Interfaces: DecryptingServiceInterface
}

embedded {
  Java:
    "prova.DecryptingService" in DecryptingServiceOutputPort
}

constants {
    FILENAME = "received.txt"
}

main {

    sendStringhe( request )( response ) {

        with( rq_w ) {

            response = "messaggio ricevuto"
            println@Console( "il messaggio criptato ricevuto è: " )(  )
            println@Console( request.message )(  )
            // println@Console( "La chiave pubblica è: " )(  )
            // println@Console( request.publickey )(  )
            .filename = FILENAME;
            .content = request + "\n";
            .append = 1

        }
        
        writeFile@File( rq_w )()

        //DECRIPTAZIONE

        DecryptedMessage@DecryptingServiceOutputPort( request )( response );

        //...

    }
}