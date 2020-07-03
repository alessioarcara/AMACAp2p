include "console.iol"
include "runtime.iol"
include "interfacce.iol"


outputPort port {
    Location: "socket://localhost:10001" 
    Protocol: http
    Interfaces: interfacciaB
}

/* outputPort controllerPort {
    Location: "socket://localhost:9999" 
    Protocol: http
    Interfaces: IController
} */

// outputPort userMonitorPort {
//     Location: "socket://localhost:9995"
//     Protocol: http
//     Interfaces: IUserMonitor
// }

init {
    //counter = -1

    /* // CHECK PORT 9999 for Controller.ol
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
    } */

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
            users.(response).name = response
            users.(response).port = portNum
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

define getUsers {
    condition = true
    portNum = 10001
    while(condition) {
        scope( e ){
            install( IOException  => {
                condition = false
            })
            sendAck@port( "ack" )(response)
            users.(response).name = response
            users.(response).port = portNum
            portNum = portNum + 1
            port.location = "socket://localhost:" + portNum
        }
    } 
}

define searchChat
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
}

define leavingNetwork
{
    getUsers

    //trova chi è l'ultimo peer entrato in rete
    lastPeerPort = 0
    foreach ( peer : users ) {
        println@Console("\n" + users.(peer).name + " : " + users.(peer).port + "\n")()
        lastPeerPort = users.(peer).port
    }

    //controlla che non sia lui stesso l'ultimo peer
    if(lastPeerPort != user.port) {
        println@Console("\nLibero porta " + user.port + "\n")()
        //libera la port attualmente occupata occupando la port 9999 (inutilizzata)
        port.location = "socket://localhost:" + user.port
        changePort@port(9999)()
        //posiziona l'ultimo peer nella posizione del peer uscente (questo)
        port.location = "socket://localhost:" + lastPeerPort
        println@Console("\nSposto " + lastPeerPort + " a " + user.port + "\n")()
        changePort@port(user.port)()
    }
}


main {

    registerForInput@Console()()

    //SHOW RETE INFO
    println@Console("\nLIST OF ONLINE USERS:\n")()
    foreach ( u : users ) {
        println@Console(users.(u).name + "\n")()
    }

    //SIGN IN
    //check username
    condition = true
    while ( condition ) {
        print@Console("\nInserisci username: ")()
        in( user.name )
        if( is_defined(users.(user.name).name) ) {
            println@Console( "\nUsername già utilizzato.\n" )(  )
        } else {
            condition = false
        }
    }
    port.location = "socket://localhost:" + num_port
    sendInfo@port(user.name)()
    user.port = num_port
    //setUsername@controllerPort(user)(ack)
    println@Console("\nBenvenuto " + user.name + "\n")()
    println@Console("\nUtilizzi la porta " + user.port + "\n")()
    
    //WAIT FOR INSTRUCTION
    status = true
    while ( status ) {
        print@Console("\nInserisci istruzione: ")()
        in(instruction)

        if ( instruction == "EXIT" ) {
            leavingNetwork
            status = false
        } 
        else if ( instruction == "CHAT" ) {
            searchChat
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