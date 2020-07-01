include "console.iol"

execution { concurrent }

interface Ipeer {
    RequestResponse: sendStringhe( string )( string )
}

outputPort clientPort {
    Location: "socket://localhost:11000"
    Protocol: http
    Interfaces: Ipeer
}

inputPort serverPort {
    Location: "socket://localhost:10999"
    Protocol: http
    Interfaces: Ipeer
}

define menuIniziale {
    //CREAZIONE PEER, RICERCA SERVIZI...
    println@Console( "Inserimento peer nella rete" )()
    println@Console( "Ricerca servizio..." )()
    //...
}

main {

    sendStringhe( request )( response ) {
        println@Console("\nTi hanno inviato " + request + "\n")()
        response = "ACK"
    }

    // SEARCH FREE PORT .
    condition = true
    portNum = 11000
    
    while( condition ) {
        clientPort.location = "socket://localhost:" + portNum
        condition2 = true
        
        scope( Exception ){
            install( IOException  => println@Console( "\nSearching...\n")() );
            sendStringhe@clientPort( "ack" )( response )
            portNum = portNum + 1
            condition2 = false
        }
        
        if(condition2) {
            condition = false //esco dal while

            if(portNum == 11000) {
                clientPort.location = "socket://localhost:11001"
                serverPort.location = "socket://localhost:11000" 
            }
            else {
                clientPort.location = "socket://localhost:11000"
                serverPort.location = "socket://localhost:" + portNum
            }
        }
    }

    // SEND MESSAGE .
    println@Console("\n" + portNum + "\n")()


    // LATO SERVER .
    

}

/* define Server {

    // LATO SERVER
    [
        sendStringhe( request )( response ) {
            println@Console("\nTi hanno inviato " + request + "\n")()
            response = "ACK"
        }
    ]

}  */