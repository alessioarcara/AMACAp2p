include "console.iol"
include "Interfacce&Tipi.iol"

execution{ concurrent }

inputPort portaStampaConsole {
    Location: "socket://localhost:9002"
    Protocol: http
    Interfaces: teniamoTraccia
}

init {
    println@Console( "CONSOLE DI TRACCIAMENTO" )(  )
}

main {
     [stampa( message )] {
        println@Console( message )()       
    }
}