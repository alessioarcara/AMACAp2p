include "console.iol"
include "interfacce.iol"

execution{ concurrent }


inputPort port {
    Location: LOCATION
    Protocol: http
    Interfaces: interfacciaB
}


main {
    
    [
        sendStringhe( request )( response ) {
            response = "ACK"
            println@Console(">>" + request + "\n")()
        }
    ]

    [
        sendAck( ack )( response ) {
            response = "ack"
        }
    ]
    

}

