include "console.iol"

interface ISwing {
  RequestResponse: aperturaMenu( string )( void )
}

outputPort JavaSwingConsolePort {
    interfaces: ISwing
}

embedded {
  Java: "blend.JavaSwingConsole" in JavaSwingConsolePort
}

main {

    aperturaMenu@JavaSwingConsolePort("Eccomiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii")( message.text )
    println@Console( message.text )()
    in( var )
}