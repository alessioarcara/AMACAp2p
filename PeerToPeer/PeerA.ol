include "console.iol"
include "runtime.iol"
include "interfacce.iol"
include "ui/swing_ui.iol"
include "semaphore_utils.iol"
include "ConsoleStampa.ol"

outputPort port {
    Protocol: http
    Interfaces: interfacciaB
}

outputPort portaStampaConsole {
    Location: "socket://localhost:9000"
    Protocol: http
    Interfaces: teniamoTraccia
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

    install( IOException => {
                println@Console( "Nessuna operazione scelta" )(  )
            })
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

    //SIGN IN
    user.port = num_port

    showInputDialog@SwingUI( "Inserisci username: " )( response )
    println@Console("Ciao")()
    user.name = response
    

    port.location = "socket://localhost:" + user.port
    sendInfo@port(user.name)()
    broadcastMsg

    //SHOW RETE INFO

    //println@Console("\nBenvenuto " + user.name + "\n")()
    press@portaStampaConsole("\nBenvenuto " + user.name + "\n")()

    //WAIT FOR INSTRUCTION
    status = true
    while ( status ) {
        scope( exception ) {
            showInputDialog@SwingUI( "Inserisci istruzione da eseguire: " )( response )
            instruction = response

            port.location = "socket://localhost:" + user.port
            getPeerName@port()( peer_names )
            getPeerPort@port()( peer_port )
            println@Console( #peer_names )(  )
        
            for ( i=0, i < #peer_names, i++ ) {
                users.(peer_port[i]).name = peer_names[i]
                users.(peer_port[i]).port = peer_port[i]
            }
        
            if ( instruction == "EXIT" ) {
                status = false
            } else {
                println@Console("\nIstruzione sconosciuta.")()
            }
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