include "console.iol"
include "Interfacce&Tipi.iol"

outputPort portaStampaConsole {
    Location: "socket://localhost:9002"
    Protocol: http
    Interfaces: teniamoTraccia
}

define menuIniziale {
    //Stampa del menù iniziale per la gestione dei peer e dei messaggi .
    println@Console( " -------------------------------------" )()
    println@Console( "|1. Aggiungi un nuovo peer alla rete  |" )()
    println@Console( "|2. Avvia una chat privata            |" )()
    println@Console( "|3. Avvia una chat pubblica           |" )()
    println@Console( " -------------------------------------" )()
}

init {
    registerForInput@Console()()
}

main {
    menuIniziale

    //CANALE DI COMUNICAZIONE .
    service.token = ""
    subscribeSessionListener@Console( service )() //Apro il canale di comunicazione .

    println@Console( "SEI NELLA CONSOLE" )()
    in( message )
    
    stampa@portaStampaConsole( message )

    unsubscribeSessionListener@Console( service )() //Chiudo il canale di comunicazione .
}