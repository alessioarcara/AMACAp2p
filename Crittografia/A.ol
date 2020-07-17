include "ServerInterface.iol"
include "file.iol"
include "console.iol"
include "converter.iol"
include "string_utils.iol"
include "Math.iol"
include "KeyGeneratorServiceInterface.iol"
include "EncryptingServiceInterface.iol"
include "ShaAlgorithmServiceInterface.iol"

outputPort B {
    Location: "socket://localhost:9000"
    Protocol: sodep
    Interfaces: ServerInterface, scambioChiaviInterface
}

outputPort KeyGeneratorServiceOutputPort {
  Interfaces: KeyGeneratorServiceInterface
}

outputPort EncryptingServiceOutputPort {
    Interfaces: EncryptingServiceInterface
}

outputPort ShaAlgorithmServiceOutputPort {
    Interfaces: ShaAlgorithmServiceInterface
}

embedded {
  Java:
    "prova.KeyGeneratorService" in KeyGeneratorServiceOutputPort,
    "prova.EncryptingService" in EncryptingServiceOutputPort,
    "prova.ShaAlgorithmService" in ShaAlgorithmServiceOutputPort
}

constants {
    FILENAME = "source.txt"
}

main {

    //restituzione delle due chiavi pubbliche e chiave privata

    GenerazioneChiavi@KeyGeneratorServiceOutputPort(  )( returnChiavi );

    chiaviPubbliche.publickey1 = returnChiavi.publickey1;
    chiaviPubbliche.publickey2 = returnChiavi.publickey2;    
    chiavePrivata.privatekey = returnChiavi.privatekey;

    registerForInput@Console()();

    println@Console("Vuoi avviare una chat con il peer B?") ( )
    println@Console( "" )(  )
    println@Console( "INSERISCI: *si* per iniziare la chat" )(  )
    println@Console( "INSERISCI: *no* per uscire dal programma" )(  )
    println@Console( "" )(  )
    in(a)

    toLowerCase@StringUtils( a )( a_result )
    if ( a_result == "si" ) {

        scambioChiavi@B( chiaviPubbliche )( chiaviResponse )

        while(c != "exit") {

            println@Console( "" )(  )
            println@Console( "INSERISCI: *privato* per mandare un messaggio privato" )(  )
            println@Console( "INSERISCI: *pubblico* per mandare un messaggio pubblico" )(  )
            println@Console( "INSERISCI: *exit* per uscire dal programma" )(  )
            println@Console( "" )(  )
            in(c);

            if (c == "privato"){

                println@Console( "" )(  )
                println@Console("Inserisci un messaggio: ")()
                println@Console( "" )(  )
                in(b)
                
                length@StringUtils( b )( length_b )
                if ( length_b < 64 ) {

                    //passo il plaintext al javaservice *EncryptingService*

                    request.message = b
                    request.publickey1 = chiaviResponse.publickey1
                    request.pub_priv_key = chiaviResponse.publickey2
                    request.cripto_bit = 1
                    
                    Codifica_RSA@EncryptingServiceOutputPort( request )( response )

                    //il javaservice *EncryptingService* mi ritorna il ciphertext 
                    println@Console( "" )(  )
                    println@Console( "il messaggio criptato è: "  )()
                    println@Console( response.message )(  )

                    with( w ) {
                        .filename = FILENAME;
                        .content = request.message + "\n";
                        .append = 1
                    }

                    //scrivo il File
                    writeFile@File( w )( )

                    //inserisco chiave pubblica nel messaggio
                    sendStringhe@B( response )( )

                } else { 
                    println@Console( "errore: messaggio troppo lungo" )(  )
                }
            }

            if ( c == "pubblico" ) {
                println@Console( "" )(  )
                println@Console("Inserisci un messaggio: ")()
                println@Console( "" )(  )
                in(b)

                //passo il plaintext al javaservice "ShaAlgorithmService"
                hash.message = b
                ShaPreprocessingMessage@ShaAlgorithmServiceOutputPort ( hash ) ( hash_response )

                //il javaservice "ShaAlgorithmService" ritorna l'hash del messaggio
                println@Console( "" )(  )
                println@Console( "Message Hash *H(M)* : " + hash_response.message )(  )

                //il javaservice "EncryptingService" codifica con la chiave privata l'hash del messaggio
                
                codifica.message = hash_response.message
                codifica.publickey1 = chiaviPubbliche.publickey1
                codifica.pub_priv_key = chiavePrivata.privatekey
                codifica.cripto_bit = 0

                Codifica_RSA@EncryptingServiceOutputPort( codifica )( codifica_response )

                //il javaservice "EncryptingService" ritorna il ciphertext dell'hash del messaggio
                println@Console( "" )(  )
                println@Console( "Message Crypted *K_S(H(M))* : " + codifica_response.message)()
                
                //invio al lato receiver il messaggio e il criptato con la chiave privata dell'hash del messaggio
                
                firma_digitale.plaintext = b
                firma_digitale.message = codifica_response.message
                firma_digitale.publickey1 = chiaviPubbliche.publickey1
                firma_digitale.publickey2 = chiaviPubbliche.publickey2

                sendStringhePubblico@B( firma_digitale )( )
            }
        }
    } else {
        println@Console("Esco dal programma...") ( )
    }
}        
