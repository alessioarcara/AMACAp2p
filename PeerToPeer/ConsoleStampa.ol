include "console.iol"
include "Interfacce&Tipi.iol"
include "time.iol"
include "runtime.iol"
include "ui/swing_ui.iol"

execution{ concurrent }

inputPort portaStampaConsole {
    Location: "socket://localhost:50000"
    Protocol: http
    Interfaces: teniamoTraccia
}

init {
    println@Console( "\tCONSOLE DI TRACCIAMENTO" )()
}

main {
     [press( message )()] {
        println@Console( message )()  
        if( message == "USCITA DALLA RETE IN CORSO..." ) {
            callExit@Runtime()()
            sleep@Time( 3000 )()
            showMessageDialog@SwingUI( "SEI USCITO DA AMACAp2p" )(  )
            halt@Runtime()()
        }
    }
}