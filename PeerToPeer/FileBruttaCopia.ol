include "console.iol"

interface interfaccia {
    OneWay: inviamoParola( string )
}

// inputPort PortaInput {
//     Location: "socket://localhost:12000"
//     Protocol: https
//     Interfaces: interfaccia
// }

define stampa {
    registerForInput@Console(  )()
    in( file )
    println@Console( file )()
}

main {
    peer.Alessio[ 0 ] = 2
    peer.Michael[ 1 ] = 3

    peer.Andrea[ 0 ] = 3

    stampa
}