include "console.iol"
include "runtime.iol"


interface interfacciaB {
    RequestResponse: sendStringhe( string )( string )
}

interface interfacciaC {
    RequestResponse: setCount( string )( int ),
    RequestResponse: getCount( string )( int )
}


outputPort port {
    Location: "socket://localhost:10000" 
    Protocol: http
    Interfaces: interfacciaB
}

outputPort controllerPort {
    Location: "socket://localhost:9999" 
    Protocol: http
    Interfaces: interfacciaC
}

init {
    //counter = -1

    // CHECK PORT 9999
    /* scope(e) {
        install(IOException => {
            with( emb ) {
                .filepath = "-C LOCATION=\"" + "socket://localhost:9999" + "\" Controller.ol";
                .type = "Jolie"
            };
            loadEmbeddedService@Runtime( emb )()
            counter = 1
        })
        setCount@controllerPort("ack")( counter )
    } */
    synchronized( token ) {
        if(is_defined(global.counter)) {
            global.counter = global.counter + 1
            println@Console("\nCounter aggiornato\n")()
        } else {
            global.counter = 1
        }
    }

    num_port = global.counter + 10000
    with( emb ) {
        .filepath = "-C LOCATION=\"" + "socket://localhost:" + num_port + "\" B.ol";
        .type = "Jolie"
    };
    loadEmbeddedService@Runtime( emb )() 
}

main {

    registerForInput@Console()()
    println@Console("\nSei l'utente " + global.counter + "\n")()
    println@Console("\nUtilizzi la porta " + num_port + "\n")()
    print@Console("Inserisci numero destinatario: ")()
    in( dest )
    dest_port = int(dest) + 10000
    println@Console("\nCerco porta " + dest_port + "\n\n")()
    port.location = "socket://localhost:" + dest_port

    print@Console("Ora puoi scrivere i messaggi e inviarli.\n\n")()
    in( msg )
    while(msg != "exit") {
        sendStringhe@port(msg)(response)
        //println@Console(response)()
        print@Console("\n")()
        in( msg )
        println@Console()()
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