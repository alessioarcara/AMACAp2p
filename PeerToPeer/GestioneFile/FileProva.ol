include "console.iol"
include "file.iol"
include "time.iol"

init {
    install( FileNotFound => {
        println@Console( "Errore, file non trovato.." )()
    })
}

main {
    richiestaLettura.filename = "Prova.txt"
    readFile@File( richiestaLettura )( risposta )
    println@Console( risposta )()

    println@Console( "MODIFICA IN CORSO FILE..." )()
    sleep@Time( 3000 )()

    with( richiestaLettura ) {
        .filename = "Prova.txt"
        .content = "File modificato"
    }

    writeFile@File( richiestaLettura )()
    // readFile@File( richiestaLettura )( risposta )
    // print@Console( risposta )()
}