include "console.iol"

interface IFace {
    RequestResponse: sendMessage( string )( void )
}

inputPort ricezioneProva {
    Location: "socket://localhost:13000"
    Protocol: http
    Interfaces: IFace
}

outputPort invioProva {
    Location: "socket://localhost:13001"
    Protocol: http
    Interfaces: IFace
}

init {
    registerForInput@Console()()
}

main {
    flag = true
    while( flag ) {
        sendMessage( request )( response ) {
            if( request == "exit" ) {
                flag = false
            } else {
                println@Console( request )()
            }
        }

        if( !(request == "exit") ) {
            print@Console( "Invia risposta: " )()
            in( message )

            if( message == "exit" ) {
                flag = false
                sendMessage@invioProva( message )()
            } else { 
                sendMessage@invioProva( message )()
            }
        }
    }
}