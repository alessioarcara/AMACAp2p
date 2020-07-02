include "console.iol"
include "runtime.iol"
include "interfacce.iol"


outputPort port {
    Location: "socket://localhost:10001" 
    Protocol: http
    Interfaces: interfacciaB
}

outputPort controllerPort {
    Location: "socket://localhost:9999" 
    Protocol: http
    Interfaces: IController
}

init {
    counter = -1

    // CHECK PORT 9999 for Controller.ol
    scope(e) {
        install(IOException => {
            with( emb ) {
                .filepath = "-C LOCATION=\"" + "socket://localhost:9999" + "\" Controller.ol";
                .type = "Jolie"
            };
            loadEmbeddedService@Runtime( emb )()
            counter = 1
        }) 
        setCount@controllerPort("ack")( counter )
    }

    // SEARCH THE FIRST FREE PORT
    
    condition = true
    portNum = 10001
    while(condition) {
        scope( e ){
            install( IOException  => {
                //println@Console("\nSearching free port... " + portNum + "\n")()
                num_port = portNum
                condition = false
            })
            sendAck@port( "ack" )(response)
            portNum = portNum + 1
            port.location = "socket://localhost:" + portNum
        }
    } 
    
    //num_port = counter + 10000
    with( emb ) {
        .filepath = "-C LOCATION=\"" + "socket://localhost:" + num_port + "\" B.ol";
        .type = "Jolie"
    };
    loadEmbeddedService@Runtime( emb )() 
}

main {

    registerForInput@Console()()

    //SIGN IN
    println@Console("\n" + counter + "\n")()
    print@Console("\nUsername: ")()
    in( user.name )
    user.port = num_port
    setUsername@controllerPort(user)(ack)
    println@Console("\nBenvenuto " + user.name + "\n")()
    println@Console("\nUtilizzi la porta " + user.port + "\n")()

    //SEARCH CHAT
    print@Console("Inserisci nome destinatario: ")()
    in( user.dest )

    user.dest.port = int(user.dest) + 10000
    println@Console("\nCerco porta " + user.dest.port + "\n\n")()
    port.location = "socket://localhost:" + user.dest.port

    //START CHATTING
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