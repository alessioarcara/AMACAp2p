include "console.iol"
include "runtime.iol"
include "interfacce.iol"
include "ui/swing_ui.iol"


outputPort port {
    Protocol: http
    Interfaces: interfacciaB, IGroup
}

outputPort portaStampaConsole {
    Location: "socket://localhost:30000"
    Protocol: http
    Interfaces: teniamoTraccia
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
                .filepath = "-C LOCATION=\"" + "socket://localhost:" + portNum + "\" PeerB.ol";
                .type = "Jolie"
            };
            loadEmbeddedService@Runtime( emb )()
            num_port = portNum
            condition = false
        }
    }

    //Gestione errore dovuto al button "cancel" nelle SwingUI .
    install( TypeMismatch => {
        if( !is_defined( user.name ) ) {
            press@portaStampaConsole( "Un utente si è arrestato inaspettatamente!" )()
        } else {
            press@portaStampaConsole( user.name + " si è arrestato inaspettatamente!" )()
        }
    })
}

define startChat {
    //START CHATTING
    scope( e ) {

        install( IOException => println@Console( "L'utente è andato offline.")() )

        msg.username = user.name 
        port.location = "socket://localhost:" + dest_port

        //invia richiesta di chat al destinatario
        chatRequest@port( user.name )( response )
        if ( response ) {
            // print@Console("Ora puoi scrivere i messaggi e inviarli.\n\n")()
            // in( msg.text )
            press@portaStampaConsole( user.name + " ha iniziato la comunicazione con " + dest )()
            showInputDialog@SwingUI( user.name + "\nOra puoi scrivere i messaggi e inviarli.\nEXIT per uscire" )( responseMessage )
            msg.text = responseMessage
            
            while( msg.text != "EXIT" ) {
                sendStringhe@port( msg )( response )
                print@Console("\n")()
                
                showInputDialog@SwingUI( user.name + "\nInserisci messaggio ( 'EXIT' per uscire ):" )( responseMessage )
                msg.text = responseMessage

                if ( msg.text == "EXIT" ) {
                    sendStringhe@port( msg )( response )
                    press@portaStampaConsole( user.name + " ha abbandonato la comunicazione con " + dest )()
                } else {
                    println@Console( msg.text )()
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
                broadcast@port( user )
            }
        }
    }
}

main {

    println@Console( "\nUtilizzi la porta " + num_port + "\n" )()


    //SIGN IN
    user.port = num_port

    showInputDialog@SwingUI( "Inserisci username: " )( responseUser )
    user.name = responseUser

    port.location = "socket://localhost:" + user.port
    sendInfo@port( user )()
    broadcastMsg

    port.location = "socket://localhost:" + user.port //Cambio la porta dopo aver eseguito il broadcastMsg .

    //Verifichiamo tutte le volte se un peer abbia eventualmente cambiato nome .
    infoUser@port()( responseNewUser )
    user.name = responseNewUser //Setto eventualmente il nuovo nome .

    //Stampo su monitor il peer aggiunto alla rete .
    press@portaStampaConsole( user.name + " si è unito/a alla rete!" )()


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
                //inserisci nome gruppo da creare
                showInputDialog@SwingUI( user.name + "\nInserisci nome gruppo da creare" )( groupName )

                // group.name = groupName
                // group.port = user.port
                verifyGroup@port( groupName )( responseGroup )

                println@Console( responseGroup )()

                if( responseGroup ) {
                    press@portaStampaConsole( "Il gruppo " + groupName + " è già presente" )()
                } else {
                    press@portaStampaConsole( "Il gruppo " + groupName + " può essere creato" )()
                    addGroup@port( groupName )
                }

                //Controlla che non ci sia già un gruppo con quel nome
                //crea processo figlio => un peer hosta il gruppo, se il peer in questione esce, il gruppo viene smantellato
                println@Console()()
                //creare un processo PeerGroup e poi fare l'embedding
            } else {
                println@Console("\nIstruzione sconosciuta.")()
            }
    }   

        /* condition = true
        portNum = 11000
        while(condition) {
            scope( e ){
                install( IOException  => println@Console("\nSearching...\n")());
                sendStringhe@port( args[0] )( response )
                println@Console("\nIl servizio B è nella porta " + portNum + "\n")()
                condition = false
            }
            portNum = portNum + 1
            port.location = "socket://localhost:" + portNum
        } */
}