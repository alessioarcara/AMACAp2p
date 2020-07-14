include "console.iol"

interface ISwing {
  RequestResponse: aperturaConsole( void )( void )
}

outputPort JavaSwingConsolePort {
    interfaces: ISwing
}

embedded {
  Java:
    "blend.JavaSwingConsole" in JavaSwingConsolePort
}

main {
    aperturaConsole@JavaSwingConsolePort()()
    in( var )
}