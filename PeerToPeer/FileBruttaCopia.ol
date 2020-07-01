include "console.iol"

interface interfaccia {
    OneWay: inviamoParola( string )
}

inputPort PortaInput {
    Location: "socket://localhost:12000"
    Protocol: https
    Interfaces: interfaccia
}

define stampaSomma {
    println@Console( peer.Alessio[ 0 ] + peer.Michael[ 1 ] + peer.Andrea[ 0 ] )(  )
}

main {
    peer.Alessio[ 0 ] = 2
    peer.Michael[ 1 ] = 3

    peer.Andrea[ 0 ] = 3
    stampaSomma
}