include "interfacce.iol"
include "console.iol"
include "file.iol"
include "time.iol"


outputPort Porta {
    Location: "socket://localhost:12000"
    Protocol: http
    Interfaces: invioMessaggio
}

constants{
    FILENAME="file_messaggi.txt"
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
