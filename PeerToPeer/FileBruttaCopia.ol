include "console.iol"
include "ui/swing_ui.iol"
include "semaphore_utils.iol"

//execution{ concurrent }

// interface interfaccia {
//     RequestResponse: inviamoParola( string )
// }

// inputPort PortaInput {
//     Location: "socket://localhost:3000"
//     Protocol: https
//     Interfaces: interfaccia
// }

// outputPort PortaOutput {
//     Location: "socket://localhost:3000"
//     Protocol: https
//     Interfaces: interfaccia
// }

// define stampa {
//     registerForInput@Console(  )()
//     in( file )
//     println@Console( file )()
// }

init {
    registerForInput@Console()()
}

main {
    // //CANALE DI COMUNICAZIONE .
    // service.token = ""
    // subscribeSessionListener@Console( service )() //Apro il canale di comunicazione .

    // println@Console( "SEI NELLA CONSOLE" )()
    // in( message )
    
    // unsubscribeSessionListener@Console( service )() //Chiudo il canale di comunicazione .
    
    // User.peer[ 0 ] = "Andrea"
    // User.peer[ 1 ] = "Michael"

    // for( i = 0, i < #User.peer, i++ ) {
    //     println@Console( User.peer[ i ])()
    // }

    // //UTILIZZO SWING_UI .
    // showInputDialog@SwingUI( "Username nuovo utente: " )( User )
    // println@Console( User )()

    // showYesNoQuestionDialog@SwingUI( "Cosa scegli?" )( response )
    // println@Console( response )()


    semaphoreOne.name = "semaphoreOne"
    semaphoreOne.permits = 0

    release@SemaphoreUtils( semaphoreOne )();

    for( i = 0, i < 10, i++ ) {
        println@Console( "Ciclo numero: " + i )()

        x = 100;

        {   p1 |
            p2
        };

        println@Console( x )()
        println@Console()()
    }

    println@Console()()
}

define p1 {
    acquire@SemaphoreUtils( semaphoreOne )() 
            println@Console( "Prima sezione" )()
            x = x + 10
    release@SemaphoreUtils( semaphoreOne )()
}

define p2 {
    acquire@SemaphoreUtils( semaphoreOne )() 
        println@Console( "Seconda sezione" )()
            x = x - 10
    release@SemaphoreUtils( semaphoreOne )()
}