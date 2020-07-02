include "ServerInterface.iol"
include "file.iol"
include "console.iol"
include "converter.iol"
include "string_utils.iol"
include "Math.iol"
include "KeyGeneratorServiceInterface.iol"
include "EncryptingServiceInterface.iol"
// include "DecryptingServiceInterface.iol"

outputPort B {
    Location: "socket://localhost:9000"
    Protocol: sodep
    Interfaces: ServerInterface
}

outputPort KeyGeneratorServiceOutputPort {
  Interfaces: KeyGeneratorServiceInterface
}

outputPort EncryptingServiceOutputPort {
    Interfaces: EncryptingServiceInterface
}

embedded {
  Java:
    "prova.KeyGeneratorService" in KeyGeneratorServiceOutputPort,
    "prova.EncryptingService" in EncryptingServiceOutputPort
}

constants {
    FILENAME = "source.txt"
}

main {

    //restituzione delle due chiavi pubbliche e chiave privata

    restituzioneChiavi@KeyGeneratorServiceOutputPort(  )( returnChiavi );

    chiavi << returnChiavi;

    println@Console( "" )(  )
    println@Console( "Prima chiave PUBBLICA: " )(  )
    println@Console( chiavi.publickey1 )(  )
    println@Console( "" )(  )
    println@Console( "Seconda chiave PUBBLICA: " )(  )
    println@Console( chiavi.publickey2 )(  )
    println@Console( "" )(  )
    println@Console( "Chiave PRIVATA: " )(  )
    println@Console( chiavi.privatekey )(  )      

    registerForInput@Console()();

    while(a != "exit") {

        println@Console( "" )(  )
        println@Console("Inserisci un messaggio: ")();
        in(a)

        //passo il plaintext al javaservice *EncryptingService*
        request.message = a;
        request.publickey1 = chiavi.publickey1;
        request.publickey2 = chiavi.publickey2;
        request.privatekey = chiavi.privatekey;
        EncryptedMessage@EncryptingServiceOutputPort( request )( response );

        //il javaservice *EncryptingService* mi ritorna il ciphertext 
        println@Console( "" )(  )
        println@Console( "il messaggio criptato è: "  )()
        println@Console( response.message )(  )
        
        println@Console( "vuoi mandare il messaggio? SI/NO " )(  )

        in(b)
        toUpperCase@StringUtils( b )( bresult )

        if ( bresult == "SI" ) {
            println@Console( "<< Messaggio spedito >>" )(  )

            with( w ) {
            
                .filename = FILENAME;
                .content = response.message + "\n";
                .append = 1
            }

            //scrivo il File
            writeFile@File( w )()
            
            //inserisco chiave pubblica nel messaggio
            response.publickey = chiavi.publickey1;
            sendStringhe@B( response )( responseStringhe )
            println@Console("<< " + responseStringhe + " >>")()

        } else {

            println@Console( "Messaggio non spedito" )(  )

        }
    }
}
