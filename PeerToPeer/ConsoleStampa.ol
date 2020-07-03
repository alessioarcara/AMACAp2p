include "console.iol"
include "Interfacce&Tipi.iol"
include "time.iol"
include "runtime.iol"

execution{ concurrent }

inputPort portaStampaConsole {
    Location: "socket://localhost:9000"
    Protocol: http
    Interfaces: teniamoTraccia
}

init {
    println@Console( "\t\tCONSOLE DI TRACCIAMENTO" )()
}

main {
     [press( message )()] {
        println@Console( message )()  
        if( message == "USCITA DALLA RETE IN CORSO..." ) {
            callExit@Runtime()()
            sleep@Time( 3000 )()
            halt@Runtime()()
        }
    }
}