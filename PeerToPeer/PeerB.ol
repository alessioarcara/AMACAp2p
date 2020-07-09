include "console.iol"
include "interfacce.iol"
include "string_utils.iol"
include "ui/swing_ui.iol"


execution{ concurrent }

inputPort port {
    Location: LOCATION
    Protocol: http
    Interfaces: interfacciaB
}

outputPort out {
    Protocol: http
    Interfaces: interfacciaB
}

outputPort portaStampaConsole {
    Location: "socket://localhost:30000"
    Protocol: http
    Interfaces: teniamoTraccia
}

init {
    global.user.name = "undefined"
    global.user.port = 0
    global.count = 0
    global.peer_names[0] = void
    global.peer_port[0] = void
    //registerForInput@Console()()
}

main {

    //BROADCAST
    [broadcast( newuser )] {
        global.count = global.count + 1

        //Controllo che non ci sia un peer già registrato con lo stesso nome
        condition = false

        //toUpperCase@StringUtils(newuser.name)(resp1)
        for ( i = 0, i < #global.peer_names, i++ ) {
            //toUpperCase@StringUtils(global.peer_names[i])(resp2)
            if( newuser.name == global.peer_names[i] || newuser.name == global.user.name ) {
                condition = true
            }
        }
        //se l'username è già occupato, viene aggiunto alla fine un numero
        if ( condition ) {
            newuser.name = newuser.name + global.count
        }

        global.peer_names[global.count] = newuser.name
        global.peer_port[global.count] = newuser.port

        out.location = "socket://localhost:" + newuser.port
        hello@out( global.user )

        //println@Console("\n\n" + newuser.name + " si è unito/a alla rete!\n")()
        //press@portaStampaConsole( newuser.name + " si è unito/a alla rete!" )()
    }


    //HELLO
    [hello( peer )] {
        println@Console(peer.name + " è online.")()
        //toUpperCase@StringUtils(peer.name)(resp1)
        //toUpperCase@StringUtils(global.user.name)(resp2)
        if( peer.name == global.user.name ) {
            out.location = "socket://localhost:" + peer.port
            getCount@out()(counter)

            tempUserName = global.user.name  //Variabile d'appoggio per registrare il nome da modificare .
            global.user.name = global.user.name + counter
            //println@Console("Il tuo nome è stato cambiato in " + global.user.name)()
            press@portaStampaConsole( "Il nome " + tempUserName + " è stato cambiato in " + global.user.name )()

        }
        global.peer_names[global.count] = peer.name
        global.peer_port[global.count] = peer.port
        global.count = global.count + 1
    }


    //METODO CHE RESTITUISCE IL COUNTER
    [
        getCount()(response) {
            response = global.count
        }
    ]
    
    
    //METODO PER SCAMBIARSI MESSAGGI
    [
        sendStringhe( request )( response ) {
            response = "ACK"
            println@Console(request.username + " : " + request.text + "\n")()
        }
    ]

    //METODO PER DIALOGI TRA CLIENT-SERVER DELLO STESSO PEER
    [
        sendInfo( self )(response) {
            global.user.name = self.name
            global.user.port = self.port
        }
    ]
    [
        searchPeer( username )( port ) {
            port = 0
            for ( i=0, i<#global.peer_names, i++ ) {
                if(global.peer_names[i]==username) {
                    port = global.peer_port[i]
                }
            }
        }
    ]

    //RICEVI RICHIESTA DI CHAT
    [
        chatRequest( username )( response ) {
            showYesNoQuestionDialog@SwingUI(username + " vuole inviarti un messaggio. Vuoi accettare ed iniziare a ricevere messaggi da " + username + ".")( resp )
            if( int( resp ) == 0 ) {
                response = true
                println@Console("Per rispondere a " + username + " avvia una chat con lui.")()
            } else {
                response = false
            }
        }
    ]
    

    //PORTA PER INVIARE IL NUOVO UTENTE CON NOME CAMBIATO ( se il nome non viene cambiato, 
    //restituisce sempre lo stesso global.user.name ).
    [
        informazione()( response ) {
            response = global.user.name
        }
    ]
}