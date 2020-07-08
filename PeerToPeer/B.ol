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
    global.count = 0
    global.peer_names[0] = void
    global.peer_port[0] = void
}

main {

    //BROADCAST
    
    [broadcast( user )] {
        println@Console("\n\n" + user.name + " si è unito alla rete!\n")()
        global.peer_names[global.count] = user.name
        global.peer_port[global.count] = user.port
        global.count = global.count + 1
        //println@Console("Utente numero: " + global.count)()
        /* global.users.(user.port).name = user.name
        global.users.(user.port).port = user.port
        println@Console(global.users.(user.port).port)() */
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
    [
        getPeerName()( response ) {
            response << global.peer_names
            println@Console( #global.peer_names )(  )
        }
    ]
    [
        getPeerPort()( response ) {
            response << global.peer_port
        }
    ]
    [
        getUsers()( response ) {
            for ( i=0, i < #global.peer_names, i++ ) {
                users.(global.peer_port[i]).name = global.peer_names[i]
                users.(global.peer_port[i]).port = global.peer_port[i]
            }
            foreach ( u : users ) {
                println@Console( users.(u).name )(  )
            }
            response << users
        }
    ]

    
}

