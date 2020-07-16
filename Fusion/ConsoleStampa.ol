include "console.iol"
include "interfacce.iol"
include "time.iol"
include "runtime.iol"
include "ui/swing_ui.iol"

execution{ concurrent }

interface ISwing {
  RequestResponse: aperturaConsole( void )( void )
  RequestResponse: modificaConsole( string ) ( void )
}

outputPort JavaSwingConsolePort {
    interfaces: ISwing
}

embedded {
  Java:
    "blend.JavaSwingConsole" in JavaSwingConsolePort
}

inputPort portaStampaConsole {
    Location: "socket://localhost:30000"
    Protocol: http
    Interfaces: teniamoTraccia
}

init {
    aperturaConsole@JavaSwingConsolePort()()
    println@Console( "CONSOLE DI TRACCIAMENTO" )()
}

main {
     [
        press( message )() {
            println@Console( message )()
            modificaConsole@JavaSwingConsolePort( message )()
            if( message == "USCITA DALLA RETE IN CORSO..." ) {
                callExit@Runtime()()
                sleep@Time( 3000 )()
                showMessageDialog@SwingUI( "SEI USCITO DA AMACAp2p" )(  )
                halt@Runtime()()
            }
        }
     ]
}