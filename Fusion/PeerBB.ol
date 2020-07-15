include "console.iol"
include "interfacce.iol"
include "string_utils.iol"
include "ui/swing_ui.iol"
include "EncryptingServiceInterface.iol"
include "DecryptingServiceInterface.iol"
include "KeyGeneratorServiceInterface.iol"
include "time.iol"


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
    global.peer_port[ 0 ] = 0

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
    [broadcast( newuser.port )] {
        out.location = "socket://localhost:" + newuser.port
        //gestione dell'errore nel caso in cui si invia un "hello" ad un gruppo
        scope(e) {
            install( IOException => a=0)
            hello@out( global.user )
        }
    }

    //HELLO
    [hello( peer )] {
        println@Console( peer.name + " è online." )()

        global.peer_names[ global.count ] = peer.name
        global.peer_port[ global.count ] = peer.port
        global.count = global.count + 1

    }

    //RESPOND TO HELLO
    [sendHi( peer )] {
        
        temp = -1
        for( i = 0, i < #global.peer_names, i++ ) {

            //Registro la posizione .
            if( peer.name == global.peer_names[i] ) {
                temp = i
            }
        }

        if ( temp > -1 ) {
            global.peer_names[ temp ] = peer.name
            global.peer_port[ temp ] = peer.port
        } else {
            global.peer_names[ global.count ] = peer.name
            global.peer_port[ global.count ] = peer.port
            global.count = global.count + 1
        }
    }

    //METODO PER IL LOGIN (impone di inserire un username non utilizzato) 
    //inoltre, manda agli altri peer la propria porta e il proprio username
    [
        login(user.port)(response) {

            condition = true    //Condizione per inserire user . 
            while ( condition ) {

                install( TypeMismatch => {
                    if( responseUser instanceof void ) {
                        press@portaStampaConsole( "Un utente si è arrestato inaspettatamente!" )()
                    }
                })
                
                showInputDialog@SwingUI( "Inserisci username: " )( responseUser )
                isOriginal = true
                for ( i = 0, i < #global.peer_names, i++ ) {
                    
                    //UpperCase per la verifica degli user .
                    toUpperCase@StringUtils( string(global.peer_names[i]) )( responsePeer )
                    toUpperCase@StringUtils( responseUser )( responseUserUppercase )
                    if( responsePeer == responseUserUppercase ) {
                        isOriginal = false
                    }
                }
                if ( isOriginal ) {
                    condition = false
                    response = responseUser
                } else {
                    showMessageDialog@SwingUI("Username già utilizzato.")()
                }
            }

            global.user.name = responseUser
            global.user.port = user.port

            for( i=0, i < #global.peer_port, i++ ) {
                if ( global.peer_port[0] != 0 ) {
                    scope( e ) {
                        install( CorrelationError => i=i )
                        out.location = "socket://localhost:" + global.peer_port[i]
                        sendHi@out( global.user )
                    }
                }
            }
        }
    ]


    //METODO CHE RESTITUISCE IL COUNTER
    [
        getCount()( response ) {
            response = global.count
        }
    ]
    
    
    //METODO PER SCAMBIARSI MESSAGGI
    [
        sendStringhe( plaintextRequest )( response ) {

            request.message = plaintextRequest.text
            request.publickey1 = global.chiaviPubbliche.publickey1
            request.privatekey = global.chiavePrivata.privatekey
            Decodifica_RSA@DecryptingServiceOutputPort( request )( plainTextResponse )
            
            response = "ACK"  //Utilizzabile per verificare la corretta ricezione di messaggio .

            //Formato settato .
            requestFormat.format = "yyyy/MM/dd HH:mm:ss"

            //Regisrazione data ed ora del messaggio .
            getCurrentDateTime@Time( requestFormat )( responseDateTime )

            //Stampa messaggio con data, ora e username .
            println@Console( responseDateTime + "\t" + plaintextRequest.username + " : " + plainTextResponse.message + "\n" )()
        }
    ]

    //METODO PER DIALOGI TRA CLIENT-SERVER DELLO STESSO PEER
    [
        searchPeer( username )( port ) {
            port = 0
            for( i=0, i<#global.peer_names, i++ ) {
                if( global.peer_names[i] == username ) {
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
                println@Console( "Per rispondere a " + username + " avvia una chat con lui." )()
            } else {
                response = false
            }
        }
    ]
    

    //RESTITUZIONE CHIAVI PUBBLICHE .
    [
        richiestaChiavi()( response ) {
            response.publickey1 = global.chiaviPubbliche.publickey1
            response.publickey2 = global.chiaviPubbliche.publickey2
        }
    ]

    //RICEZIONE MESSAGGIO DA GRUPPO
    [forwardMessage( msg )] {

        //Settaggio formato data e ora .
        requestFormat.format = "yyyy/MM/dd HH:mm:ss"

        //Servizio per permettere di stabilire la data e ora corrente del messaggio .
        getCurrentDateTime@Time( requestFormat )( responseDateTime )
        
        println@Console( responseDateTime + "\t" + msg.username + ": " + msg.text )()
    }
}