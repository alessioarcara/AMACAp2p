include "console.iol"
include "interfacce.iol"
include "string_utils.iol"
include "ui/swing_ui.iol"
include "EncryptingServiceInterface.iol"
include "DecryptingServiceInterface.iol"
include "KeyGeneratorServiceInterface.iol"
include "ShaAlgorithmServiceInterface.iol"
include "time.iol"
include "file.iol"


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

define settaggioCaratteri {
    //Salvo la stringa contenente lo username .
    stringa = responseUser

    //Ricavo la lunghezza massima .
    length@StringUtils( responseUser )( length )
    
    with( stringa ) {
        .begin = 0
        .end = 1
    }
    
    //Setto la prima lettera Up .
    substring@StringUtils( stringa )( responseFirst )
    toUpperCase@StringUtils( responseFirst )( responseUp )

    with( stringa ) {
        .begin = 1
        .end = length
    }

    //Setto tutte le altre lettere a Lower .
    substring@StringUtils( stringa )( responseSecond )
    toLowerCase@StringUtils( responseSecond )( responseLower )
}

define riconoscimentoUserGroup {
    flag = false

    stringaGroupUser = peer.name
    length@StringUtils( stringaGroupUser )( lengthGroupUser )

    with( stringaGroupUser ) {
        .begin = lengthGroupUser - 1
        .end = lengthGroupUser
    }

    substring@StringUtils( stringaGroupUser )( responseLast )
    toUpperCase@StringUtils( responseLast )( responseUpLast )
    
    if( responseLast == responseUpLast ) {
        flag = true
    }
}

main {

    //invia il proprio user
    [sendUsername(peer)] {
        global.peer_names[ global.count ] = peer.name
        global.peer_port[ global.count ] = peer.port
        global.count = global.count + 1  
    }

    //modifica la variabile global.user.port
    [
        setPort(port)() {
            global.user.port = port
        }
    ]


    //GENERAZIONE CHIAVI PUBBLICHE E PRIVATA PER PEER .
    [
        generateKey()() {
            //Contatto il Javaservice per acquisire le chiavi .
            GenerazioneChiavi@KeyGeneratorServiceOutputPort()( returnChiavi )

            global.chiaviPubbliche.publickey1 = returnChiavi.publickey1
            global.chiaviPubbliche.publickey2 = returnChiavi.publickey2   
            global.chiavePrivata.privatekey = returnChiavi.privatekey
        }
    ]

    //BROADCAST 
    [broadcast( newuser.port )] {
        out.location = "socket://localhost:" + newuser.port 
        if ( global.user.name == "undefined" ) {
            global.peer_names[ global.count ] = "undefined"
            global.peer_port[ global.count ] = newuser.port
            global.count = global.count + 1   
        } 
        hello@out( global.user )
    }


    //HELLO
    [hello( peer )] {

        //RICONOSCIMENTO GRUPPO O USER 
        riconoscimentoUserGroup

        if( flag ) {
            println@Console( "Il gruppo " + peer.name + " è online!" )()
        } else {
            println@Console( peer.name + " è online." )()
        }

        //AGGIUNTA SYNCHRONIZED PER RISOLVERE PROBLEMI DI SOVRASCRITTURA E DOPPI INCREMENTI 
        synchronized( lock ) {
            global.peer_names[ global.count ] = peer.name
            global.peer_port[ global.count ] = peer.port
            global.count = global.count + 1   
        }

    }

    //RESPOND TO HELLO
    [sendHi( peer )] {
        synchronized( lock ) {
            temp = -1 //Settaggio a -1 per successivo controllo 
            for( i = 0, i < #global.peer_names, i++ ) {

                //Registro la posizione 
                if( peer.name == global.peer_names[i] ) {
                    temp = i
                }
            }

            //Se temp > -1 allora sovrascriviamo 
            if ( temp > -1 ) {
                global.peer_names[ temp ] = peer.name
                global.peer_port[ temp ] = peer.port
            } else {
                global.peer_names[ global.count ] = peer.name
                global.peer_port[ global.count ] = peer.port
                global.count = global.count + 1
            }   
        }
    }

    //METODO PER IL LOGIN (impone di inserire un username non utilizzato) 
    //inoltre, manda agli altri peer la propria porta e il proprio username tramite il servizio "sendHi"
    [
        login(user.port)(response) {
            //ciclo while che si interrompe solo quando viene inserito un username valido
            condition = true    
            synchronized( lockLogin ) {
                while ( condition ) {

                    install( TypeMismatch => {
                        if( responseUser instanceof void ) {
                            scope( exceptionConsole ) {
                                install( IOException => println@Console("Errore, console non disponibile!")() )
                                press@portaStampaConsole( "Un utente si è arrestato inaspettatamente!" )()
                            }
                        }
                    })
                
                
                    showInputDialog@SwingUI( "Inserisci username: " )( responseUser )
                    isOriginal = true

                    //Acquisisco lunghezza stringa per controllo aggiuntivo 
                    length@StringUtils( responseUser )( lengthUserWord )

                    //Controllo per verificare se uno username ha inserito un nome troppo corto .
                    if( lengthUserWord < 2 ){
                        isOriginal = false
                    }
                    
                    for ( i = 0, i < #global.peer_names, i++ ) {
                        
                        //UpperCase per la verifica degli user 
                        toUpperCase@StringUtils( string(global.peer_names[i]) )( responsePeer )
                        toUpperCase@StringUtils( responseUser )( responseUserUppercase )
                        
                        if( responsePeer == responseUserUppercase ) {
                            isOriginal = false
                        }
                    }

                    if ( isOriginal ) {
                        condition = false

                        //Richiamo define per sistemare i caratteri 
                        settaggioCaratteri

                        //Genero username completo combinando i caratteri restituiti dalla define 
                        response = responseUp + responseLower
                    } else {
                        showMessageDialog@SwingUI("Username già utilizzato o nome troppo corto")()
                    }
                }

                //Registrazione user e port
                global.user.name = response
                global.user.port = user.port
            }

            for( i=0, i < #global.peer_port, i++ ) {
                if ( global.peer_port[0] != 0 ) { //controllo che sia stata settata almeno una porta
                    out.location = "socket://localhost:" + global.peer_port[i]
                    sendHi@out( global.user )
                }
            }
        }
    ]

    
    //METODO PER SCAMBIARSI MESSAGGI PRIVATI .
    [
        sendString( plaintextRequest )( response ) {

            request.message = plaintextRequest.text
            request.publickey1 = global.chiaviPubbliche.publickey1
            request.pub_priv_key = global.chiavePrivata.privatekey
            request.cripto_bit = 1 //Settato ad 1 permette di sfruttare RSA con padding 
            Decodifica_RSA@DecryptingServiceOutputPort( request )( plainTextResponse )
            
            response = "ACK"  //Utilizzabile per verificare la corretta ricezione di messaggio 

            //Formato settato 
            requestFormat.format = "dd/MM/yyyy HH:mm:ss"

            //Regisrazione data ed ora del messaggio 
            getCurrentDateTime@Time( requestFormat )( responseDateTime )

            //Stampa messaggio con data, ora e username 
            println@Console( responseDateTime + "\t" + plaintextRequest.username + " : " + plainTextResponse.message )()

            //Scrivo nel file 
            //Metodo synchronized perchè non ci possono essere scritture contemporanee, questo 
            //perchè più peer possono scrivere ad un singolo peer 
            synchronized( lockFile ) {
                with( richiesta ) {
                        .filename = "BackupChat/DATABASE_" + global.user.name + ".txt"
                        .content = responseDateTime + "\t" + plaintextRequest.username + ": " + plainTextResponse.message + " \n"
                        .append = 1
                    }
                writeFile@File( richiesta )()
            }
        }
    ]

    //METODO PER DIALOGI TRA CLIENT-SERVER DELLO STESSO PEER
    [
        searchPeer( username )( port ) {
            port = 0
            for( i=0, i<#global.peer_names, i++ ) {
                if( global.peer_names[i] == username ) {
                    port = global.peer_port[i]
                    //gestione del caso "undefined"
                    if(username == "undefined") {
                        global.peer_names[i] = "undef"
                    }
                }
            }
        }
    ]

    //RICEVI RICHIESTA DI CHAT
    [
        chatRequest( username )( response ) {
            showYesNoQuestionDialog@SwingUI( username + " vuole inviarti un messaggio. Vuoi accettare ed iniziare a ricevere messaggi da " + username + "?" )( responseQuestion )
            if( responseQuestion == 0 ) {
                response = true
                println@Console( "Per rispondere a " + username + " avvia una chat con lui/lei." )()

                //Scrittura apice del messaggio 
                synchronized( lockFile ) {
                    with( richiesta ) {
                        .filename = "BackupChat/DATABASE_" + global.user.name + ".txt"
                        .content = "\nINIZIO A RICEVERE MESSAGGI DA " + username + "\n"
                        .append = 1
                    }
                    writeFile@File( richiesta )() //Scrittura su file settato in precedenza 
                }
            } else {
                response = false
            }
        }
    ]
    

    //RESTITUZIONE CHIAVI PUBBLICHE PER CHAT PRIVATA .
    [
        richiestaChiavi()( response ) {
            response.publickey1 = global.chiaviPubbliche.publickey1
            response.publickey2 = global.chiaviPubbliche.publickey2
        }
    ]

    //RESTITUZIONE CHIAVI PERSONALI PER CHAT PUBBLICA E FIRMA .
    [
        richiestaProprieChiavi()( response ) {
            response.publickey1 = global.chiaviPubbliche.publickey1
            response.publickey2 = global.chiaviPubbliche.publickey2
            response.privatekey = global.chiavePrivata.privatekey
        }
    ]

    //RICEZIONE MESSAGGIO DA GRUPPO .
    [forwardMessage( msg )] {

        firma.message = msg.message         //messaggio codificato K^-( H(m) )
        firma.publickey1 = msg.publickey1   //ricezione prima componente chiave pubblica (n)
        firma.pub_priv_key = msg.publickey2 //ricezione seconda componente chiave pubblica (e)
        firma.cripto_bit = 0
        
        //DECODIFICA DEL CRIPTATO DELL'HASH DEL MESSAGGIO --> K+( K-( H(m) ) ) .
        //(Hash acquisito)
        Decodifica_RSA@DecryptingServiceOutputPort( firma )( firma_decodificata )

        //GENERAZIONE HASH DEL MESSAGGIO RICEVUTO IN CHIARO .
        //(Hash generato)
        plaintext.message = msg.text  //messaggio in chiaro da passare alla funzione per generarne l'hash
        ShaPreprocessingMessage@ShaAlgorithmServiceOutputPort( plaintext )( hash_plaintext )

        //CONFRONTO TRA HASH ACQUISITO E GENERATO .
        if( hash_plaintext.message == firma_decodificata.message ) {

            //Settaggio formato data e ora .
            requestFormat.format = "dd/MM/yyyy HH:mm:ss"

            //Servizio per permettere di stabilire la data e ora corrente del messaggio .
            getCurrentDateTime@Time( requestFormat )( responseDateTime )
            
            println@Console( responseDateTime + "\t" + msg.username + ": " + msg.text )()

            //Settaggio per scrittura messaggio su file .
            synchronized( lockFile ) {
                with( richiesta ) {
                    .filename = "BackupChat/DATABASE_" + global.user.name + ".txt"
                    .content = responseDateTime + "\t" + msg.username + ": " + msg.text + " \n"
                    .append = 1
                }
            
                //Scrittura effettiva del messaggio .
                writeFile@File( richiesta )()
            }

        } else {
            println@Console( "Il messaggio è corrotto." )()
        }
    }
}