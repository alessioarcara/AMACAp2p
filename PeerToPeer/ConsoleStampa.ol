include "console.iol"
include "Interfacce&Tipi.iol"

execution{ concurrent }

inputPort portaStampaConsole {
    Location: "socket://localhost:9000"
    Protocol: http
    Interfaces: teniamoTraccia
}

init {
    println@Console( "\t\t\tCONSOLE DI TRACCIAMENTO" )()
}

main {
     [press( message )( void )] {
        println@Console( message )()       
    }
}