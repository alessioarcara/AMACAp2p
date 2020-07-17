include "interfacce.iol"
include "console.iol"
include "file.iol"
include "time.iol"

execution{concurrent}

inputPort Porta {
    Location: "socket://localhost:12000"
    Protocol: http
    Interfaces: invioMessaggio
}

constants{
    FILENAME="file_messaggi.txt"
} 

init {
    install( FileNotFound => {
        println@Console( "Errore, file non trovato.." )()
    })
}

main{
    [
        sendMessage(message)(){
            println@Console(message)()
            //metodo che ritorna la data di invio del messaggio
            getCurrentDateTime@Time()(Data)
            //da aggiungere metodo che ritorna lo username che ha inviato il messaggio 
            
            //ora stampo i messaggi nel file, con la rispettiva ora di invio 
                with( richiesta ) {
                    .filename = FILENAME;
                    .content = "Data e ora: "+Data+" "+message+ " \n";
                    .append = 1
                    
                }
                writeFile@File( richiesta )()
        }
        //devo fare controlli nel caso in cui entrano due users 
    ]
}
