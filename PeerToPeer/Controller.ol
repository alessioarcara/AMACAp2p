include "console.iol"
include "interfacce.iol"

execution{ concurrent }

inputPort controllerPort {
    Location: "socket://localhost:9999" 
    Protocol: http
    Interfaces: IController
}

init {
    global.counter = 1
    users.name[0] = "PROVA"
}

main {

    [
        setCount(request)(response) {

            global.counter = global.counter + 1
            response = global.counter
            //println@Console("\n\nUn utente ha eseguito l'accesso\n\n")()
        }
    ]

    [
        getCount(request)(response) {
            response = global.counter 
        }
    ]

    [
        setUsername( user )( ack ) {
            users.name[user.port] = user.name
            ack = true
        }
    ]

    /* [
        setUserPort( username )( userport ) {

        }
    ] */

}