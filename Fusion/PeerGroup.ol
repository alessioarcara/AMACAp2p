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
    //global.group.host = 0
    global.members[0] = void
}

main {

    [verify()] {
        println@Console("  ==>  VERIFICA")()
    } 

    //inizializza nome e porta del gruppo
    [
        setGroup(request)() {
            global.group.name = request.name
            global.group.port = request.port
            //global.group.host = request.host
            global.members[0] = request.host
        }
    ]

    //metodo per quando riceve un messaggio di broadcast
    [broadcast( newuser )] {
        out.location = "socket://localhost:" + newuser
        hello@out( global.group )
    }

    //metodo per rispondere a un saluto
    [hello( peer )] {
        out.location = "socket://localhost:" + peer.port
        sendHi@out(global.group)
    }


    //metodo per aggiungere nuovi peer al gruppo
    [
        enterGroup(peer)() {
            for ( i=0, i < #global.members, i++ ) {
                out.location = "socket://localhost:" + global.members[i]
                msg.username = "***"
                msg.text = peer.name + " è entrato nel gruppo!"
                forwardMessage@out(msg)
            }
            global.members[#global.members] = peer.port
        }
    ]

    //metodo per ricevere messaggi dai peer e spedirli a tutti gli altri peer partecipanti
    [sendMessage(msg)] {
        for ( i=0, i < #global.members, i++ ) {
            out.location = "socket://localhost:" + global.members[i]
            forwardMessage@out(msg)
        }
    }


}
