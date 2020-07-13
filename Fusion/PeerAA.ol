include "console.iol"
include "runtime.iol"
include "interfacce.iol"
include "ui/swing_ui.iol"
include "EncryptingServiceInterface.iol"
include "DecryptingServiceInterface.iol"
include "KeyGeneratorServiceInterface.iol"


outputPort port {
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

constants {
    menu =  "1. Chat privata ( CHAT )\n2. Chat gruppo ( CREA GRUPPO )\n3. Esci dalla rete ( EXIT )\n"
}

init {
    // SEARCH THE FIRST FREE PORT
    condition = true
    portNum = 10001
    while( condition ) {
        scope( e ){
            install( RuntimeException  => {
                portNum = portNum + 1
            })
            with( emb ) {
                .filepath = "-C LOCATION=\"" + "socket://localhost:" + portNum + "\" PeerBB.ol"
                .type = "Jolie"
            };
            loadEmbeddedService@Runtime( emb )()
            num_port = portNum
            condition = false
        }
    }

    //Gestione errore dovuto al button "cancel" nelle SwingUI .
    /* install( TypeMismatch => {
        if( !is_defined( user.name ) ) {
            press@portaStampaConsole( "Un utente si è arrestato inaspettatamente!" )()
        } else {
            press@portaStampaConsole( user.name + " si è arrestato inaspettatamente!" )()
        }
    }) */
}

define startChat {
    //START CHATTING
    scope( e ) {

        install( IOException => println@Console( "L'utente è andato offline.")() )

        msg.username = user.name 
        port.location = "socket://localhost:" + dest_port

        //invia richiesta di chat al destinatario
        chatRequest@port( user.name )( enter )

        if ( enter ) {

            //Recupero chiavi pubbliche del destinatario .
            richiestaChiavi@port()( chiaviPubblicheDestinatario )
            request.publickey1 = chiaviPubblicheDestinatario.publickey1
            request.publickey2 = chiaviPubblicheDestinatario.publickey2

            press@portaStampaConsole( user.name + " ha iniziato la comunicazione con " + dest )()
            
            responseMessage = ""
            
            while( responseMessage != "EXIT" ) {
                
                showInputDialog@SwingUI( user.name + "\nInserisci messaggio ( 'EXIT' per uscire ):" )( responseMessage )         

                if ( responseMessage == "EXIT" ) {
                    //sendStringhe@port( msg )( response )
                    press@portaStampaConsole( user.name + " ha abbandonato la comunicazione con " + dest )()
                } else {
                    //Passo il plaintext al javaservice *EncryptingService*
                    request.message = responseMessage
                    Codifica_RSA@EncryptingServiceOutputPort( request )( response )
                    msg.text = response.message  
                    sendStringhe@port( msg )( response )
                    //println@Console( msg.text )()
                }
                println@Console()()
            }
        } else {
            println@Console( "L'utente ha rifiutato la tua richiesta di chattare." )()
        }
    }
}

define broadcastMsg {
    for( i = 10001, i < 10101, i++ ) {
        scope( e ) {
            install( IOException => i = i /*println@Console("-- Error with " + i + " --")()*/ )
            if( i != user.port ) {
                port.location = "socket://localhost:" + i
                broadcast@port( user.port )
            }
        }
    }
}

main {

    println@Console( "\nUtilizzi la porta " + num_port + "\n" )()


    //Invio broadcast
    user.port = num_port

    broadcastMsg

    //Iscrizione nella rete
    port.location = "socket://localhost:" + user.port
    login@port(user.port)(user.name)


    //Stampo su monitor il peer aggiunto alla rete .
    press@portaStampaConsole( user.name + " si è unito/a alla rete!" )()

    //GENERAZIONE CHIAVI .
    generateKey@port()


    //WAIT FOR INSTRUCTION
    status = true
    while ( status ) {

        showInputDialog@SwingUI( "User: " + user.name + "\n" + menu + "\nInserisci istruzione: " )( responseIstruzione )
        instruction = responseIstruzione

        port.location = "socket://localhost:" + user.port

        if ( instruction == "EXIT" ) {
            status = false
            press@portaStampaConsole( user.name + " ha abbandonato la rete" )()
        } 
        else 
            if ( instruction == "CHAT" ) {

                showInputDialog@SwingUI( user.name + "\nInserisci username da contattare: " )( responseContact )
                dest = responseContact

                searchPeer@port( dest )( dest_port )
            
                if ( dest_port == 0 ) {
                    println@Console( "L'username ricercato non esiste." )(  )
                } else {
                    startChat
                }
        }
        else 
            if ( instruction == "CREA GRUPPO") {

                // SEARCH THE FIRST FREE PORT
                condition = true
                portNum = 10001
                while( condition ) {
                    scope( e ){
                        install( RuntimeException  => {
                            portNum = portNum + 1
                        })
                        with( emb ) {
                            .filepath = "-C LOCATION=\"" + "socket://localhost:" + portNum + "\" PeerGroup.ol"
                            .type = "Jolie"
                        };
                        loadEmbeddedService@Runtime( emb )()
                        group.port = portNum
                        condition = false
                    }
                }

                //inserisci nome gruppo da creare e controllo
                condition = true
                while(condition) {
                    showInputDialog@SwingUI( user.name + "\nInserisci nome gruppo da creare" )( group.name )

                    port.locaiton = "socket://localhost:" + user.port
                    searchPeer@port( group.name )( response )
                    
                    if ( response != 0 ) {
                        condition = false
                    } else {
                        println@Console( "Impossibile creare un gruppo con questo nome." )(  )
                    }
                }
                port.location = "socket://localhost:" + group.port
                setGroupName@port( group )()
                
                //messaggio broadcast per avvisare gli altri peer della creazione del gruppo
                for( i = 10001, i < 10101, i++ ) {
                    scope( e ) {
                        install( IOException => i = i)
                        if( i != user.port ) {
                            port.location = "socket://localhost:" + i
                            broadcast@port( group )
                        }
                    }
                }


            } else {
                println@Console("\nIstruzione sconosciuta.")()
            }
    }   

}