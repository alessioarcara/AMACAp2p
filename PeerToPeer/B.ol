include "console.iol"
include "interfacce.iol"

execution{ concurrent }


inputPort port {
    Location: LOCATION
    Protocol: http
    Interfaces: interfacciaB
}

init {
    global.user.name = "undefined"
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
            //println@Console("----->" + global.user.name + "\n")()
            response = global.user.name
        }
    ]

    [
        sendInfo( username )(response) {
            global.user.name = username
            //println@Console("----->" + global.user.name + "\n")()
        }
    ]
    
}

