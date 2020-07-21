include "console.iol"
include "runtime.iol"
include "string_utils.iol"
include "interfacce.iol"
include "ui/swing_ui.iol"
include "EncryptingServiceInterface.iol"
include "DecryptingServiceInterface.iol"
include "KeyGeneratorServiceInterface.iol"
include "ShaAlgorithmServiceInterface.iol"
include "exec.iol"
include "file.iol"
include "time.iol"


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

outputPort ShaAlgorithmServiceOutputPort {
    Interfaces: ShaAlgorithmServiceInterface
}

outputPort JavaSwingConsolePort {
  interfaces: ISwing
}

embedded {
  Java:
    "blend.KeyGeneratorService" in KeyGeneratorServiceOutputPort,
    "blend.EncryptingService" in EncryptingServiceOutputPort,
    "blend.DecryptingService" in DecryptingServiceOutputPort,
    "blend.ShaAlgorithmService" in ShaAlgorithmServiceOutputPort,
    "blend.JavaSwingConsole" in JavaSwingConsolePort
}

constants {
    menu =  "1. Chat privata ( CHAT )\n2. Chat gruppo ( CREA )\n3. Entra in un gruppo ( PARTECIPA )\n4. Esci dalla rete ( EXIT )",
    limiteLunghezzaMessaggio = 63
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
    install( TypeMismatch => {
        trim@StringUtils( user.name )( responseTrim ) //Trim dell strina passata come request .
        if( is_defined( user.name ) && !( responseTrim instanceof void ) ) {
            press@portaStampaConsole( user.name + " si è arrestato/a inaspettatamente!" )()
        } else {
            press@portaStampaConsole( "Un utente si è arrestato inaspettatamente!" )()
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
        chatRequest@port( user.name )( enter )

        if ( enter ) {
            
            with( richiesta ) {
                    .filename = "BackupChat/DATABASE_"+user.name+".txt";
                    .content = "\nINIZIO A MANDARE MESSAGGI A "+dest+"\n";
                    .append = 1
                }
                writeFile@File( richiesta )()
                
            //Recupero chiavi pubbliche del destinatario .
            richiestaChiavi@port()( chiaviPubblicheDestinatario )
            request.publickey1 = chiaviPubblicheDestinatario.publickey1
            request.pub_priv_key = chiaviPubblicheDestinatario.publickey2
            request.cripto_bit = 1

            press@portaStampaConsole( user.name + " ha iniziato la comunicazione con " + dest )()
            
            responseMessage = ""
            
            while( responseMessage != "EXIT" ) {
                scope( exception ) {
                    install( StringIndexOutOfBoundsException => {
                        press@portaStampaConsole( user.name + " ha inserito un messaggio troppo lungo!" )() 
                    })
                    showInputDialog@SwingUI( user.name + "\nInserisci messaggio per " + dest + " ( 'EXIT' per uscire ):" )( responseMessage )         

                    getCurrentDateTime@Time()(Data)
                         with( richiesta ) {
                            .filename = "BackupChat/DATABASE_"+user.name+".txt";
                            .content = Data+"\t"+user.name+": "+responseMessage+ " \n";
                            .append = 1
                        }
                        writeFile@File( richiesta )()
                    
                    if ( responseMessage == "EXIT" ) {
                        press@portaStampaConsole( user.name + " ha abbandonato la comunicazione con " + dest )()
                    } else {
                        //Passo il plaintext al javaservice .
                        if( !( #responseMessage > limiteLunghezzaMessaggio ) ){ //Controllo lunghezza messaggio .
                            request.message = responseMessage
                            Codifica_RSA@EncryptingServiceOutputPort( request )( response )
                            msg.text = response.message  
                            sendStringhe@port( msg )( response )
                            //println@Console( msg.text )()
                        }
                    }
                    //println@Console()()
                }
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

define startGroupChat {
    
    //inizializzazione persistenza 
    with( richiesta ) {
        .filename = "BackupChat/DATABASE_"+user.name+".txt";
        .content = "\nINIZIO COMUNICAZIONE CON GRUPPO "+group.name+"\n";
        .append = 1
    }
    writeFile@File( richiesta )()
    
    
    //START CHATTING
    scope( e ) {

        install( IOException => {
            println@Console( "L'host del gruppo è andato offline.")()
            press@portaStampaConsole( user.name + " non può più scrivere. Gruppo " + group.name + " eliminato!")()
        })

        msg.username = user.name 
        press@portaStampaConsole( user.name + " ha iniziato la comunicazione con il gruppo " + group.name )()
        
        responseMessage = ""
        
        while( responseMessage != "EXIT" ) {
            scope( exception ) {
                /* install( StringIndexOutOfBoundsException => {
                    press@portaStampaConsole( user.name + " ha inserito un messaggio troppo lungo!" )() 
                }) */
                showInputDialog@SwingUI( user.name + "\nInserisci messaggio per il gruppo " + group.name + " ( 'EXIT' per uscire ):" )( responseMessage )         

                if ( responseMessage == "EXIT" ) {
                    exitGroup@port( user )()
                    press@portaStampaConsole( user.name + " ha abbandonato il gruppo " + group.name )()
                } else {
                    hash.message = responseMessage
                    ShaPreprocessingMessage@ShaAlgorithmServiceOutputPort ( hash ) ( hash_response )

                    port.location = "socket://localhost:" + user.port
                    richiestaProprieChiavi@port()( chiaviPersonaliResponse )

                    codifica.message = hash_response.message
                    codifica.publickey1 = chiaviPersonaliResponse.publickey1
                    codifica.pub_priv_key = chiaviPersonaliResponse.privatekey
                    codifica.cripto_bit = 0

                    Codifica_RSA@EncryptingServiceOutputPort( codifica )( codifica_response )
                    
                    msg.text = responseMessage
                    msg.message = codifica_response.message
                    msg.publickey1 = chiaviPersonaliResponse.publickey1
                    msg.publickey2 = chiaviPersonaliResponse.publickey2

                    port.location = "socket://localhost:" + group.port
                    sendMessage@port( msg )
                }
            }
        }
    }
}

main {

    //println@Console( "\nUtilizzi la porta " + num_port + "\n" )()

    //Invio broadcast
    user.port = num_port

    broadcastMsg

    //Iscrizione nella rete
    port.location = "socket://localhost:" + user.port
    login@port(user.port)(user.name)


    //Stampo su monitor il peer aggiunto alla rete .
    press@portaStampaConsole( user.name + " si è unito/a alla rete! " + "( " + num_port + " )" )()

    //creazione file persistenza
    scope(exceptionFile){
        install( IOException => exec@Exec("NUL> BackupChat/DATABASE_"+user.name+".txt")())
        exec@Exec("touch BackupChat/DATABASE_"+user.name+".txt")()
    }
    
    //GENERAZIONE CHIAVI .
    generateKey@port()()

    //WAIT FOR INSTRUCTION
    status = true
    while ( status ) {

        // showInputDialog@SwingUI( "User: " + user.name + "\n" + menu + "\nInserisci istruzione: " )( responseIstruzione )
        aperturaMenu@JavaSwingConsolePort( "User: " + user.name + "\nSeleziona istruzione: " )( responseIstruzione )
        instruction = responseIstruzione

        port.location = "socket://localhost:" + user.port

        if ( instruction == 2 ) {
            status = false
            press@portaStampaConsole( user.name + " ha abbandonato la rete" )()
        } 
        else 
            if ( instruction == 0 ) {

                showInputDialog@SwingUI( user.name + "\nInserisci username da contattare: " )( responseContact )
                dest = responseContact

                searchPeer@port( dest )( dest_port )
            
                if ( dest_port == 0 ) {
                    println@Console( "L'username ricercato non esiste." )(  )
                } else {
                    startChat
                }
        }
        else if ( instruction == 3 ) {

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

            //Inserisci nome gruppo da creare e controllo
            condition = true
            while(condition) {
                showInputDialog@SwingUI( user.name + "\nInserisci nome gruppo da creare" )( groupName )

                //Settaggio gruppo ad UpperCase .
                toUpperCase@StringUtils( groupName )( group.name )

                port.location = "socket://localhost:" + user.port
                searchPeer@port( group.name )( response )

                if ( response == 0 ) {
                    condition = false
                } else {
                    println@Console( "Impossibile creare un gruppo con questo nome." )()
                    press@portaStampaConsole( user.name + " ha provato a creare il gruppo " + group.name + " già esistente!" )()
                }
            }
            port.location = "socket://localhost:" + group.port
            group.host = user.port
            setGroup@port( group )()
            
            //messaggio broadcast per avvisare gli altri peer della creazione del gruppo
            for( i = 10001, i < 10101, i++ ) {
                scope( e ) {
                    install( IOException => i = i)
                    if( i != group.port ) {
                        port.location = "socket://localhost:" + i
                        broadcast@port( group.port )
                    }
                }
            }

            //inizio chat del gruppo
            startGroupChat

        } 
        else if ( instruction == 1 ) {
            scope(e) {
                install( IOException => {
                    println@Console("L'host del gruppo è andato offline.")()
                    press@portaStampaConsole( user.name + " ha ricercato un gruppo " + group.name + " inesistente!" )() 
                })

                showInputDialog@SwingUI( user.name + "\nInserisci nome del gruppo: " )( responseContact )
                group.name = responseContact

                searchPeer@port( group.name )( group.port )
            
                if ( group.port == 0 ) {
                    println@Console( "Il gruppo ricercato non esiste." )()
                    press@portaStampaConsole( user.name + " ha ricercato un gruppo " + group.name + " inesistente!")()
                } else {
                    port.location = "socket://localhost:" + group.port
                    enterGroup@port(user)() 
                    println@Console( "\nBenvenuto nel gruppo " + group.name + "!\n" )(  )
                    startGroupChat
                }
            }

        }
        else if( instruction == -1 ) {
            status = false
            press@portaStampaConsole( user.name + " ha abbandonato la rete" )()
        } else {
            println@Console("\nIstruzione sconosciuta.")()
        }
    }   
    
}