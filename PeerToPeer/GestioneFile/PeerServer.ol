include "console.iol"
include "interfaces.iol"
include "file.iol"

execution{ concurrent }

inputPort portaRicezione {
    Location: "socket://localhost:12000"
    Protocol: sodep
    Interfaces: ServerInterface, INumber
}

constants {
    FILENAME = "received.txt"
}

main {
    // [
    //     invioNumero( x )( risposta ) {
    //         risposta = x.first * x.second
    //         println@Console( "I numeri ricevuti sono: " + x.first + " e " + x.second )()
    //     }
    // ]

      setFileContent( request )( response ){
        with( richiesta ) {
            .filename = FILENAME;
            .content = request.first + request.second;
            .append = 1
        }
        writeFile@File( richiesta )()
    }
}