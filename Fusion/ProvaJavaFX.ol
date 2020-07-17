include "console.iol"

interface ISwing {
  RequestResponse: aperturaMenu( string )( int )
}

outputPort JavaSwingConsolePort {
  interfaces: ISwing
}

embedded {
  Java: "blend.JavaSwingConsole" in JavaSwingConsolePort
}

main {
  
  aperturaMenu@JavaSwingConsolePort("Eccomiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii")( response )
  println@Console( response )()

}