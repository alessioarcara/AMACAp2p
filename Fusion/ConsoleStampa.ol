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
            modificaConsole@JavaSwingConsolePort( message )()
        }
     ]
}