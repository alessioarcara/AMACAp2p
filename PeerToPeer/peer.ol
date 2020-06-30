include "console.iol"

execution { concurrent }

interface Ipeer {
    RequestResponse: sendStringhe( string )( string )
}

inputPort port {
    Location: "socket://localhost:11000"
    Protocol: http
    Interfaces: Ipeer
}

outputPort port {
    Location: "socket://localhost:11000"
    Protocol: http
    Interfaces: Ipeer
}

main {

    // SEARCH FREE PORT
    condition = true
    portNum = 11000
    while(condition) {
        port.location = "socket://localhost:" + portNum
        condition2 = true
        scope( e ){
            install( IOException  => println@Console("\nSearching...\n")());
            sendStringhe@port( "ack" )( response )
            portNum = portNum + 1
            condition2 = false
        }
        if(condition2) {
            condition = false
        }
    }


    // SEND MESSAGE
    println@Console("\n" + portNum + "\n")()




}

/* define Server {

    // LATO SERVER
    [
        sendStringhe( request )( response ) {
            println@Console("\nTi hanno inviato " + request + "\n")()
            response = "ACK"
        }
    ]

} */






