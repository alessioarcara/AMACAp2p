include "interfacce.iol"
include "console.iol"

execution{concurrent}

inputPort Porta {
    Location: "socket://localhost:12000"
    Protocol: http
    Interfaces: Interfaccia1
}

main{
    [
        sendMessage(message)(){
            println@Console(message)()
            
        }
    ]
}
