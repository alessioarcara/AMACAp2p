include "Console.iol"
include "Interfaccia.iol"

interface firstInterface {
    RequestResponse: sendString( string )( string )
}

outputPort firstPort {
    Location: "socket://localhost:12000"
    Protocol: http
    Interfaces: firstInterface
}

main {
    sendString@firstPort( args[0] )( response )
    println@Console( "Il Peer B ha inviato " + response )()
}