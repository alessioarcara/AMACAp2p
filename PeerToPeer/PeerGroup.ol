include "console.iol"
include "interfacce.iol"

inputPort GroupPort {
    Location: LOCATION
    Protocol: http
    Interfaces: IGroup
}

outputPort portaStampaConsole {
    Location: "socket://localhost:30000"
    Protocol: http
    Interfaces: teniamoTraccia
}

init {
    global.group_name[ 0 ] = void
    global.countGroup = 0
}

main {
    //VERIFICA SE IL GRUPPO INSERITO ESISTE .
    [
        verifyGroup( groupName )( response ) {
            //Variabile flag da restituire .
            flag = false

            println@Console( #global.countGroup )()

            for( i = 0, i < #global.group_name, i++ ) {
                
                if( groupName == global.group_name[ i ] ) {
                    flag = true
                }
            }

            //Restituisco la risposta .
            response = flag
        }
    ]


    //AGGIUNTA GRUPPO .
    [addGroup( request )] {
        global.group_name[ global.countGroup ] = request
        global.countGroup = global.countGroup + 1
    }
}
