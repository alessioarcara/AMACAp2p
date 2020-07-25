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
    //APERTURA CONSOLE .
    aperturaConsole@JavaSwingConsolePort()()
    global.counter = 0 //Setto un contatore .
}

main {
    [
        press( message )() {
            synchronized( lockConsole ) { //AGGIUNTA DI SYNCHRONIZED PER PROGRESSIONE CONTATORE .
                global.counter = global.counter + 1
                modificaConsole@JavaSwingConsolePort( global.counter + ". " + message )()   
            }
        }
    ]
}