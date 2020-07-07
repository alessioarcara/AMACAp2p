include "console.iol"

interface IFace {
    RequestResponse: sendMessage( string )( void )
}

inputPort ricezioneProva2 {
    Location: "socket://localhost:13001"
    Protocol: http
    Interfaces: IFace
}

outputPort invioProva {
    Location: "socket://localhost:13000"
    Protocol: http
    Interfaces: IFace
}

init {
    registerForInput@Console()()
}

main {
    flag = true
    while( flag ) {
        print@Console( "Invia messaggio: " )()
        in( message )
        if( message == "exit" ) {
            flag = false
            sendMessage@invioProva( message )()
        } else {
            sendMessage@invioProva( message )()

            sendMessage( request )( response ) {
                if( request == "exit" ) {
                    flag = false
                } else {
                    println@Console( request )()
                }
            }
        }
    }
}