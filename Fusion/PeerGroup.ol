include "console.iol"
include "interfacce.iol"

execution{ concurrent }

inputPort GroupPort {
    Location: LOCATION
    Protocol: http
    Interfaces: IGroup, interfacciaB
}

outputPort out {
    Protocol: http
    Interfaces: interfacciaB, IGroup
}

outputPort portaStampaConsole {
    Location: "socket://localhost:30000"
    Protocol: http
    Interfaces: teniamoTraccia
}

init {
    global.group.name = ""
    global.group.port = 0
    global.members[0] = void

    install( ChannelClosingException => {
        println@Console( "L'host del gruppo è andato offline." )() 
    })
}

main {

    //INIZIALIZZAZIONE NOME GRUPPO E PORTA DEL GRUPPO .
    [
        setGroup( request )() {
            global.group.name = request.name
            global.group.port = request.port
            global.members[0] = request.host
        }
    ]

    //PER RICEZIONE MESSAGGI DI BROADCAST .
    [broadcast( newuser )] {
        out.location = "socket://localhost:" + newuser
        hello@out( global.group )
    }

    //metodo per rispondere a un saluto
    [hello( peer )] {
        out.location = "socket://localhost:" + peer.port
        sendHi@out( global.group )
    }


    //metodo per aggiungere nuovi peer al gruppo
    [
        enterGroup(peer)() {
            for ( i=0, i < #global.members, i++ ) {
                if ( global.members[i] != -1 ) {    
                    out.location = "socket://localhost:" + global.members[i]
                    
                    msg.username = global.group.name
                    msg.text = peer.name + " è entrato nel gruppo!"
                    forwardMessage@out(msg)
                }
            }
            global.members[#global.members] = peer.port
        }
    ]

    //RICHIESTA DI USCITA DAL GRUPPO .
    [
        exitGroup( peer )() {
            for( i=0, i < #global.members, i++ ) {
               
                if( global.members[i] == peer.port ) {
                    global.members[i] = -1   
                } else if( global.members[i] != -1 ) {
                    out.location = "socket://localhost:" + global.members[i]
                    
                    msg.username = global.group.name
                    msg.text = peer.name + " è uscito dal gruppo!"
                    forwardMessage@out(msg)
                }
            }
        }
    ]

    //metodo per ricevere messaggi dai peer e spedirli a tutti gli altri peer partecipanti
    [sendMessage(msg)] {
        for ( i=0, i < #global.members, i++ ) {
            if ( global.members[i] != -1 ) {
                out.location = "socket://localhost:" + global.members[i]
                forwardMessage@out(msg)
            }
        }
    }


}
