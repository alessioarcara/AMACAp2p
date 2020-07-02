include "ServerInterface.iol"
include "file.iol"
include "console.iol"

execution{ concurrent }

inputPort B {
    Location: "socket://localhost:9000"
    Protocol: sodep
    Interfaces: ServerInterface
}

constants {
    FILENAME = "received.txt"
}

main {

    sendStringhe( request )( response ) {

        with( rq_w ) {

            response = "messaggio ricevuto"
            println@Console( "il messaggio criptato ricevuto è: " )(  )
            println@Console( request )(  )
            println@Console( "La chiave pubblica è: " )(  )
            println@Console( request )(  )
            .filename = FILENAME;
            .content = request + "\n";
            .append = 1

        }
        
        writeFile@File( rq_w )()

        //DECRIPTAZIONE

    }
}