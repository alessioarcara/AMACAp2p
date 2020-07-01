include "Console.iol"
include "Interfacce&Tipi.iol"

execution{ concurrent }

interface firstInterface {
    RequestResponse: sendString( string )( string )
}

inputPort firstPort {
    Location: "socket://localhost:12000"
    Protocol: http
    Interfaces: firstInterface
}

main {
    sendString( request )( response ) {
        println@Console( "Il Peer A ha inviato " + request )()
        response = "ACK"
    }
}