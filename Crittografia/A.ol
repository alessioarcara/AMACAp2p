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
        println@Console( "il messaggio da java è: " + response.reply )()
        
        println@Console( "vuoi mandare il messaggio? SI/NO " )(  )
        in(b)
        toUpperCase@StringUtils( b )( bresult )
        if ( bresult == "SI" ) {
            println@Console( "Messaggio spedito" )(  )
            with ( f ) {
                .filename = "source.txt"
                .format = "base64"
            }
            readFile@File( f )( content )
            setFileContent@B( content )()
        } else {
            println@Console( "Messaggio non spedito" )(  )
        }
    //}
}