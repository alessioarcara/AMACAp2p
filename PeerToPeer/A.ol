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
    msg.username = user.dest
    print@Console("Ora puoi scrivere i messaggi e inviarli.\n\n")()
    in( msg.text )
    while(msg.text != "EXIT") {
        sendStringhe@port(msg)(response)
        //println@Console(response)()
        print@Console("\n")()
        in( msg.text )
        println@Console()()
    }
}

define broadcastMsg {
    for ( i=10001, i<65001, i++ ) {
        port.location = "socket://localhost:" + i
        broadcast@port(user)
    }
} 

/* define searchChat
{
    //SEARCH CHAT
    condition = true
    while ( condition ) {
        getUsers
        foreach ( peer : users ) {
            println@Console("\n" + users.(peer).name + " : " + users.(peer).port + "\n")()
        }
        print@Console("\nInserisci username destinatario: ")()
        in( user.dest )

        if ( user.dest == "EXIT" ) {
            condition = false
        }
        else if( is_defined(users.(user.dest).name) ) {
            port.location = "socket://localhost:" + users.(user.dest).port
            startChat
        }
        else {
            println@Console( "\nL'username inserito non è online." )(  )
        }
    }
} */


main {

    println@Console("\nUtilizzi la porta " + num_port + "\n")()

    registerForInput@Console()()

    //SIGN IN
    user.port = num_port
    print@Console( "Inserisci username: " )(  )
    in(user.name)
    port.location = "socket://localhost:" + num_port
    sendInfo@port(user.name)()

    //SHOW RETE INFO
    println@Console("\nLIST OF ONLINE USERS:\n")()
    foreach ( u : users ) {
        println@Console(users.(u).name + "\n")()
    }

    println@Console("\nBenvenuto " + user.name + "\n")()
    
    /* //WAIT FOR INSTRUCTION
    status = true
    while ( status ) {
        print@Console("\nInserisci istruzione: ")()
        in(instruction)

        if ( instruction == "EXIT" ) {
            status = false
        } 
        else if ( instruction == "CHAT" ) {
            //searchChat
        }
        else {
            println@Console("\nIstruzione sconosciuta.")()
        }
    } */

    
    

    


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