include "console.iol"
include "interfacce.iol"
include "ShaAlgorithmServiceInterface.iol"
include "EncryptingServiceInterface.iol"
include "DecryptingServiceInterface.iol"
include "KeyGeneratorServiceInterface.iol"

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

outputPort KeyGeneratorServiceOutputPort {
  Interfaces: KeyGeneratorServiceInterface
}

outputPort EncryptingServiceOutputPort {
    Interfaces: EncryptingServiceInterface
}

outputPort DecryptingServiceOutputPort {
    Interfaces: DecryptingServiceInterface
}

outputPort ShaAlgorithmServiceOutputPort {
    Interfaces: ShaAlgorithmServiceInterface
}

embedded {
  Java:
    "blend.KeyGeneratorService" in KeyGeneratorServiceOutputPort,
    "blend.EncryptingService" in EncryptingServiceOutputPort,
    "blend.DecryptingService" in DecryptingServiceOutputPort,
    "blend.ShaAlgorithmService" in ShaAlgorithmServiceOutputPort
}

init {
    global.group.name = ""
    global.group.port = 0
    global.members[ 0 ] = void

    install( ChannelClosingException => {
        println@Console( "L'host del gruppo è andato offline." )()
    })
}

main {

    //INIZIALIZZAZIONE NOME GRUPPO E PORTA DEL GRUPPO .
    [
        setGroup( request )() {
            synchronized( lockSetGroup ) {
                global.group.name = request.name
                global.group.port = request.port
                global.members[ 0 ] = request.host
            }
        }
    ]

    //PER RICEZIONE MESSAGGI DI BROADCAST .
    [broadcast( newuser )] {
        synchronized( lockBroadcastGroup ) {
            out.location = "socket://localhost:" + newuser
            hello@out( global.group )
        }
    }

    //metodo per rispondere a un saluto
    [hello( peer )] {
        synchronized( lockHelloGroup ) {
            out.location = "socket://localhost:" + peer.port
            sendHi@out( global.group )
        }
    }


    //metodo per aggiungere nuovi peer al gruppo
    [
        enterGroup(peer)() {
            synchronized( lockEnterGroup ) {
                global.members[ #global.members ] = peer.port
            }
        }
    ]

    //RICHIESTA DI USCITA DAL GRUPPO .
    [
        exitGroup( peer )() {
            synchronized( lockExitGroup ) {
                for( i=0, i < #global.members, i++ ) {
                    if( global.members[i] == peer.port ) {
                        global.members[i] = -1   
                    } 
                }
            }
        }
    ]

    //metodo per ricevere messaggi dai peer del gruppo e spedirli a tutti gli altri membri
    [sendMessage(msg)] {
        synchronized( lockSendMessageGroup ) {
            for ( i = 0, i < #global.members, i++ ) {
                if( global.members[i] != -1 ) {
                    out.location = "socket://localhost:" + global.members[i]
                    forwardMessage@out(msg)
                }
            }
        }
    }
}
