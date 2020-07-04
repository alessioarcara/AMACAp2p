include "console.iol"

define P1 {
    synchronized( lock ) {
        //println@Console( "Prima sezione" )()
        x = x + 10
    }
}

define P2 {
    synchronized( lock ) {
        //println@Console( "Seconda sezione" )()
        x = x - 10
    }
}

main {
    println@Console()()

    for( i = 0, i < 20, i++ ) {
        //println@Console( "Ciclo numero: " + i )()

        x = 100;

        {   
            P1 | P2
        };

        print@Console( x + " " )()
        // println@Console()()
    }

    println@Console()()
    println@Console()()
}