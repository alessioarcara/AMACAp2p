include "console.iol"

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

main {
    // peer.Alessio[ 0 ] = 2
    // peer.Michael[ 1 ] = 3

    // peer.Andrea[ 0 ] = 3

    // stampa

    // response = "SI"
    // while( response == "SI" ) {
    //     {   print@Console( "A" )() |
    //         print@Console( "B" )() 
    //     };

    //     {   print@Console( "C" )()|
    //         print@Console( "D" )()
    //     }
    //     println@Console()()

    //     print@Console( "Continuare?" )()
    //     in( response )
    // }

    //unsubscribeSessionListener@Console()()
    // in( film )
    // println@Console( film )()
    
    service.token = "";
    subscribeSessionListener@Console( service )(); //Apro il canale di comunicazione .
    println@Console( "SEI NELLA CONSOLE, INSERISCI UN NUMERO: " )();
    in( number );
    println@Console( "Il numero inserito è: " + number )();
    unsubscribeSessionListener@Console( service )() //Chiudo il canale di comunicazione .
}