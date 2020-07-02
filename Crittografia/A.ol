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

// outputPort DecryptingServiceOutputPort {
//     Interfaces: DecryptingServiceInterface
// }

embedded {
  Java:
    "prova.KeyGeneratorService" in KeyGeneratorServiceOutputPort,
    "prova.EncryptingService" in EncryptingServiceOutputPort
    // "prova.DecryptingService" in DecryptingServiceOutputPort
}

constants {
    FILENAME = "source.txt"
}

main {

        //restituzione delle due chiavi pubbliche e chiave privata

        restituzioneChiavi@KeyGeneratorServiceOutputPort(  )( response );

        println@Console( "" )(  )
        println@Console( "Prima chiave PUBBLICA: " )(  )
        println@Console( response.publickey1 )(  )
        println@Console( "" )(  )
        println@Console( "Seconda chiave PUBBLICA: " )(  )
        println@Console( response.publickey2 )(  )
        println@Console( "" )(  )
        println@Console( "Chiave PRIVATA: " )(  )
        println@Console( response.privatekey )(  )      

        registerForInput@Console()();

        println@Console( "" )(  )
        println@Console("Inserisci un messaggio: ")();
        in(a);

        //passo il plaintext al javaservice *EncryptingService*
        request.message = a;
        request.publickey1 = response.publickey1;
        request.publickey2 = response.publickey2;
        request.privatekey = response.privatekey;
        EncryptedMessage@EncryptingServiceOutputPort( request )( response );

        //il javaservice *EncryptingService* mi ritorna il ciphertext 
        println@Console( "" )(  )
        println@Console( "il messaggio criptato è: "  )()
        println@Console( response.reply )(  )
        
        println@Console( "vuoi mandare il messaggio? SI/NO " )(  )

        in(b)
        toUpperCase@StringUtils( b )( bresult )

        if ( bresult == "SI" ) {
            println@Console( "Messaggio spedito" )(  )

        //scrivo il messaggio nel file
        with( w ) {
            
            .filename = FILENAME;
            .content = response.reply + "\n";
            .append = 1
        }

        //leggo il messaggio dal file e lo scrivo
        writeFile@File( w )()
        setFileContent@B( response.reply )()

        } else {
            println@Console( "Messaggio non spedito" )(  )
        }
}
