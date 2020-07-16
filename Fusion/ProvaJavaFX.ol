include "console.iol"

interface ISwing {
  RequestResponse: aperturaMenu( void )( void )
}

outputPort JavaSwingConsolePort {
    interfaces: ISwing
}

embedded {
  Java:
    "blend.JavaSwingConsole" in JavaSwingConsolePort
}

main {

    aperturaMenu@JavaSwingConsolePort()()
    in( var )
}