include "console.iol"
include "runtime.iol"
include "interfacce.iol"


outputPort port {
    Protocol: http
    Interfaces: interfacciaB
}


init {

    // SEARCH THE FIRST FREE PORT
    condition = true
    portNum = 10001
    while(condition) {
        scope( e ){
            install( RuntimeException  => {
                portNum = portNum + 1
            })
            with( emb ) {
                .filepath = "-C LOCATION=\"" + "socket://localhost:" + portNum + "\" B.ol";
                .type = "Jolie"
            };
            loadEmbeddedService@Runtime( emb )()
            num_port = portNum
            condition = false
        }
    } 
}

define startChat
{
    //START CHATTING
    msg.username = user.name 
    port.location = "socket://localhost:" + dest_port
    print@Console("Ora puoi scrivere i messaggi e inviarli.\n\n")()
    in( msg.text )
    while(msg.text != "EXIT") {
        sendStringhe@port(msg)(response)
        print@Console("\n")()
        in( msg.text )
        println@Console()()
    }
}

define broadcastMsg {
    for ( i=10001, i<10101, i++ ) {
        scope(e) {
            install( IOException => i = i /*println@Console("-- Error with " + i + " --")()*/ )
            if(i != user.port) {
                port.location = "socket://localhost:" + i
                broadcast@port(user)
            }
            
        }
    }
} 

main {

    println@Console("\nUtilizzi la porta " + num_port + "\n")()

    registerForInput@Console()()

    //SIGN IN
    user.port = num_port
    print@Console( "Inserisci username: " )(  )
    in(user.name)
    port.location = "socket://localhost:" + user.port
    sendInfo@port(user)()
    broadcastMsg

    //SHOW RETE INFO

    
    //WAIT FOR INSTRUCTION
    status = true
    while ( status ) {
        print@Console("\nInserisci istruzione: ")()
        in(instruction)
        port.location = "socket://localhost:" + user.port

        if ( instruction == "EXIT" ) {
            status = false
        } 
        //else if (instruction == "LIST") {}
        else if ( instruction == "CHAT" ) {
            //searchChat
            print@Console( "\nInserisci username da contattare: " )(  )
            in(dest)
            searchPeer@port(dest)(dest_port)
            if ( dest_port == 0 ) {
                println@Console( "L'username ricercato non esiste." )(  )
            } else {
                startChat
            }
        }
        else {
            println@Console("\nIstruzione sconosciuta.")()
        }
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