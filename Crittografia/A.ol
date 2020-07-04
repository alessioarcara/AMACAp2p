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
    Interfaces: ServerInterface, scambioChiaviInterface
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

    chiaviPubbliche.publickey1 = returnChiavi.publickey1;
    chiaviPubbliche.publickey2 = returnChiavi.publickey2;    
    chiavePrivata.privatekey = returnChiavi.privatekey;

    registerForInput@Console()();

    println@Console("Vuoi avviare una chat con il peer B?") ( )
    println@Console( "" )(  )
    in(a)

    toLowerCase@StringUtils( a )( a_result )
    if ( a_result == "si" ) {

        scambioChiavi@B( chiaviPubbliche )( chiaviResponse )
        println@Console( "chiave1 :"+chiaviResponse.publickey1 )(  )
        println@Console( "chiave2 :"+chiaviResponse.publickey2 )(  )

        while(b != "exit") {

            println@Console("Inserisci un messaggio: ")()
            in(b)
            //passo il plaintext al javaservice *EncryptingService*
            request.message = b
            request.publickey1 = chiaviResponse.publickey1
            request.publickey2 = chiaviResponse.publickey2
            request.privatekey = chiavePrivata.privatekey
            EncryptedMessage@EncryptingServiceOutputPort( request )( response )

            //il javaservice *EncryptingService* mi ritorna il ciphertext 
            println@Console( "" )(  )
            println@Console( "il messaggio criptato è: "  )()
            println@Console( response.message )(  )

            with( w ) {

                .filename = FILENAME;
                .content = response.message + "\n";
                .append = 1

            }

            //scrivo il File
            writeFile@File( w )( )

            //inserisco chiave pubblica nel messaggio
            sendStringhe@B( response )( responseStringhe )
            println@Console("<< " + responseStringhe + " >>")() 
        }

    } else {

        println@Console("Esco dal programma...") ( )

    }
}
