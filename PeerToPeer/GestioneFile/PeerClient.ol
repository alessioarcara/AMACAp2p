include "console.iol"
include "interfaces.iol"
include "file.iol"

outputPort portaInvio {
    Location: "socket://localhost:12000"
    Protocol: sodep
    Interfaces: ServerInterface, INumber
}

init {
    registerForInput@Console()()
}

main {
    // print@Console( "Inserisci il primo numero da mandare: " )()
    // in( number.first )

    // print@Console( "Inserisci il secondo numero da mandare: " )()
    // in( number.second )

    // // println@Console( number instanceof int )()
    // number.first = int( number.first )
    // number.second = int( number.second )
    // // println@Console( number instanceof int )()

    // invioNumero@portaInvio( number )( risposta )
    // println@Console( risposta )()

    fileFirst.filename = "source.txt"
    fileSecond.filename = "source2.txt"

    //readFile@File( fileFirst )( content )
    readFile@File( fileFirst )( content.first )
    readFile@File( fileSecond )( content.second )
    
    setFileContent@portaInvio( content )()
}