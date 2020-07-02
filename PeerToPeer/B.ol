include "console.iol"

execution{ concurrent }

interface interfacciaB {
    RequestResponse: sendStringhe( string )( string )
}


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
    

}

