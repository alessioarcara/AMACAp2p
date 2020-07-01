include "ServerInterface.iol"
include "file.iol"
include "console.iol"
include "converter.iol"
include "string_utils.iol"
include "Math.iol"
include "CrittoServiceInterface.iol"

outputPort B {
    Location: "socket://localhost:9000"
    Protocol: sodep
    Interfaces: ServerInterface
}

outputPort CrittoServiceOutputPort {
  Interfaces: CrittoServiceInterface
}

embedded {
  Java:
    "prova.CrittoService" in CrittoServiceOutputPort
}

constants {
    FILENAME = "source.txt"
}

main {
    
    x = true;
    //while ( x == true ) {
        
        registerForInput@Console()();
  
        println@Console("Inserisci un messaggio: ")();
        in(a);
        // if ( a == "esci") {
        //     x = false
        // }

        //passo il plaintext al javaservice *Critto*
        request.message = a;
        encrypting@CrittoServiceOutputPort( request )( response );

        //il javaservice *Critto* mi ritorna il ciphertext 
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

        //leggo il messaggio dal file e lo
        writeFile@File( w )()
        setFileContent@B( response.reply )()

        } else {
            println@Console( "Messaggio non spedito" )(  )
        }
    //}
}