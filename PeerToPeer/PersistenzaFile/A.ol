include "interfacce.iol"
include "console.iol"

outputPort Porta {
    Location: "socket://localhost:12000"
    Protocol: http
    Interfaces: Interfaccia1
}

init{
    registerForInput@Console()()
}

main{
    message=""
    while(message!="exit"){
        in(message)
        sendMessage@Porta(message)()
    }
}
