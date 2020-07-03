include "console.iol"
include "Interfacce&Tipi.iol"
include "time.iol"
include "runtime.iol"
include "ui/swing_ui.iol"

outputPort portaStampaConsole {
    Location: "socket://localhost:9000"
    Protocol: http
    Interfaces: teniamoTraccia
}

inputPort portaComunicazioneDiGruppo {
    Location: "socket://localhost:50000"
    Protocol: http
    Interfaces: interfacciaDiGruppo
}

define menuIniziale {
    //Stampa del menù iniziale per la gestione dei peer e dei messaggi .
    println@Console( " -------------------------------------" )()
    println@Console( "| 1. Aggiungi un nuovo peer alla rete  |" )()
    println@Console( "| 2. Avvia una chat privata            |" )()
    println@Console( "| 3. Avvia una chat pubblica           |" )()
    println@Console( "| 4. Esci dalla rete                   |" )()
    println@Console( " -------------------------------------" )()
}

init {
    registerForInput@Console()()
}

main {
    //INIZIO OPERAZIONI .
    flag = true
    while( flag ) {
        //STAMPA MENU DI SCELTA .
        menuIniziale

        //CANALE DI COMUNICAZIONE .
        service.token = ""
        subscribeSessionListener@Console( service )() //Apro il canale di comunicazione .
        
        print@Console( "Fai la tua scelta: " )()
        in( message )
        
        unsubscribeSessionListener@Console( service )() //Chiudo il canale di comunicazione .
        
        //SCELTA .
        if( message == 1 ) {
            press@portaStampaConsole( "Aggiunta peer" )()
        } else
            if( message == 4 ) {
                press@portaStampaConsole( "USCITA DALLA RETE IN CORSO..." )()
                flag = false  //SETTAGGIO FLAG PER USCITA DAL WHILE .
            }
    }
}