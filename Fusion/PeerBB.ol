include "console.iol"
include "interfacce.iol"
include "string_utils.iol"
include "ui/swing_ui.iol"
include "EncryptingServiceInterface.iol"
include "DecryptingServiceInterface.iol"
include "KeyGeneratorServiceInterface.iol"


execution{ concurrent }

inputPort port {
    Location: LOCATION
    Protocol: http
    Interfaces: interfacciaB, IGroup
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

embedded {
  Java:
    "blend.KeyGeneratorService" in KeyGeneratorServiceOutputPort,
    "blend.EncryptingService" in EncryptingServiceOutputPort,
    "blend.DecryptingService" in DecryptingServiceOutputPort
}

init {
    global.user.name = "undefined"
    global.user.port = 0
    global.count = 0
    global.peer_names[ 0 ] = void
    global.peer_port[ 0 ] = void

    //Variabili gruppo .
    global.group_name[ 0 ] = void
    global.countGroup = 0

    //Chiavi salvate .
    global.chiaviPubbliche.publickey1 = void
    global.chiaviPubbliche.publickey2 = void
    global.chiavePrivata.privatekey = void
}

main {

    //GENERAZIONE CHIAVI .
    [generateKey()] {
        GenerazioneChiavi@KeyGeneratorServiceOutputPort()( returnChiavi )

        global.chiaviPubbliche.publickey1 = returnChiavi.publickey1
        global.chiaviPubbliche.publickey2 = returnChiavi.publickey2   
        global.chiavePrivata.privatekey = returnChiavi.privatekey
    }


    //BROADCAST
    [broadcast( newuser )] {
        global.count = global.count + 1

        //Controllo che non ci sia un peer già registrato con lo stesso nome
        condition = false


        //Si verificano gli user.name semplicemente mettendoli tutti maiuscoli .
        toUpperCase@StringUtils( newuser.name )( responseNewUser )
        toUpperCase@StringUtils( global.user.name )( responseGlobalUser )

        for ( i = 0, i < #global.peer_names, i++ ) {

            if( ( newuser.name == global.peer_names[i] ) || ( responseNewUser == responseGlobalUser ) ) {
                condition = true
            }
        }

        //Se username risulta presente in rete, si aggiunge un numero alla fine del nome
        //utilizzando global.count così da assicurare l'unicità .
        if ( condition ) {
            newuser.name = newuser.name + global.count
        }

        global.peer_names[ global.count ] = newuser.name
        global.peer_port[ global.count ] = newuser.port

        out.location = "socket://localhost:" + newuser.port
        hello@out( global.user )
    }


    //HELLO
    [hello( peer )] {
        println@Console(peer.name + " è online.")()
        
        //Controllo trasformando tutti in maiuscolo .
        toUpperCase@StringUtils( peer.name )( responsePeer )
        toUpperCase@StringUtils( global.user.name )( responseGlobalUser )
        
        if( responsePeer == responseGlobalUser ) {
            out.location = "socket://localhost:" + peer.port
            getCount@out()(counter)

            tempUserName = global.user.name  //Variabile d'appoggio per registrare il nome da modificare .
            global.user.name = global.user.name + counter
            
            press@portaStampaConsole( "Il nome " + tempUserName + " è stato cambiato in " + global.user.name )()
        }

        global.peer_names[ global.count ] = peer.name
        global.peer_port[ global.count ] = peer.port
        global.count = global.count + 1
    }


    //METODO CHE RESTITUISCE IL COUNTER
    [
        getCount()( response ) {
            response = global.count
        }
    ]
    
    
    //METODO PER SCAMBIARSI MESSAGGI
    [
        sendStringhe( plaintextRequest )( response ) {

            println@Console( "Messaggio codificato: " + plaintextRequest.text )()
            
            request.message = plaintextRequest.text
            request.publickey1 = global.chiaviPubbliche.publickey1
            request.privatekey = global.chiavePrivata.privatekey
            Decodifica_RSA@DecryptingServiceOutputPort( request )( plainTextResponse )
            
            response = "ACK"
            println@Console( plaintextRequest.username + " : " + plainTextResponse.message + "\n" )()
        }
    ]

    //METODO PER DIALOGI TRA CLIENT-SERVER DELLO STESSO PEER
    [
        sendInfo( self )( response ) {
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
            showYesNoQuestionDialog@SwingUI( username + " vuole inviarti un messaggio. Vuoi accettare ed iniziare a ricevere messaggi da " + username + "." )( responseQuestion )
            if( responseQuestion == 0 ) {
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
        infoUser()( response ) {
            response = global.user.name
        }
    ]


    //VERIFICA SE IL GRUPPO INSERITO ESISTE .
    [
        verifyGroup( groupName )( response ) {
            //Variabile flag da restituire .
            flag = false

            println@Console( #global.countGroup )()

            for( i = 0, i < #global.group_name, i++ ) {
                
                if( groupName == global.group_name[ i ] ) {
                    flag = true
                }
            }

            //Restituisco la risposta .
            response = flag
        }
    ]


    //AGGIUNTA GRUPPO .
    [addGroup( request )] {
        global.group_name[ global.countGroup ] = request
        global.countGroup = global.countGroup + 1
    }

    //RESTITUZIONE CHIAVI PUBBLICHE .
    [
        richiestaChiavi()( response ) {
            //println@Console(global.chiaviPubbliche.publickey1 + " " + global.chiaviPubbliche.publickey2 )()
            response.publickey1 = global.chiaviPubbliche.publickey1
            response.publickey2 = global.chiaviPubbliche.publickey2
        }
    ]
}