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

    //BROADCAST
    
    [broadcast( user )] {
        println@Console(user.name)()
    }
    
    
    //METODO PER SCAMBIARSI MESSAGGI
    [
        sendStringhe( request )( response ) {
            response = "ACK"
            println@Console(request.username + " : " + request.text + "\n")()
        }
    ]

    //METODO PER VERIFICARE LA PRESENZA DELL'USERNAME
    [
        sendAck( ack )( response ) {
            //println@Console("----->" + global.user.name + "\n")()
            response = global.user.name
        }
    ]

    //METODO PER DIALOGI TRA CLIENT-SERVER DELLO STESSO PEER
    [
        sendInfo( username )(response) {
            global.user.name = username
            //println@Console("----->" + global.user.name + "\n")()
        }
    ]

    
}

