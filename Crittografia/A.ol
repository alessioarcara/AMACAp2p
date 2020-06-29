include "ServerInterface.iol"
include "file.iol"
include "console.iol"
include "converter.iol"
include "string_utils.iol"
include "Math.iol"


outputPort B {
    Location: "socket://localhost:9000"
    Protocol: sodep
    Interfaces: ServerInterface
}

define stringToNumber
{
    for ( i=0, i< #aresult.result, i++ ) {
        if ( aresult.result[i] == "a" ) {
            aresult.result[i] = 11
        }
        if ( aresult.result[i] == "b" ) {
            aresult.result[i] = 22
        }
        if ( aresult.result[i] == "c" ) {
            aresult.result[i] = 33
        }
        if ( aresult.result[i] == "d" ) {
            aresult.result[i] = 44
        }
        if ( aresult.result[i] == "e" ) {
            aresult.result[i] = 55
        }
        if ( aresult.result[i] == "f" ) {
            aresult.result[i] = 66
        }
        if ( aresult.result[i] == "g" ) {
            aresult.result[i] = 77
        }
        if ( aresult.result[i] == "h" ) {
            aresult.result[i] = 88
        }
        if ( aresult.result[i] == "i" ) {
            aresult.result[i] = 99
        }
        if ( aresult.result[i] == "l" ) {
            aresult.result[i] = 101
        }
        if ( aresult.result[i] == "m" ) {
            aresult.result[i] = 111
        }
        if ( aresult.result[i] == "n" ) {
            aresult.result[i] = 122
        }
        if ( aresult.result[i] == "o" ) {
            aresult.result[i] = 133
        }
        if ( aresult.result[i] == "p" ) {
            aresult.result[i] = 144
        }
        if ( aresult.result[i] == "q" ) {
            aresult.result[i] = 155
        }
        if ( aresult.result[i] == "r" ) {
            aresult.result[i] = 166
        }
        if ( aresult.result[i] == "s" ) {
            aresult.result[i] = 177
        }
        if ( aresult.result[i] == "t" ) {
            aresult.result[i] = 188
        }
        if ( aresult.result[i] == "u" ) {
            aresult.result[i] = 199
        }
        if ( aresult.result[i] == "v" ) {
            aresult.result[i] = 201
        }
        if ( aresult.result[i] == "z" ) {
            aresult.result[i] = 211
        }
        if ( aresult.result[i] == " " ) {
            aresult.result[i] = 777
        }
    }
}

define encryptionRSA
{
    p = 11
    q = 13
    n = p*q
    z = (p-1)*(q-1)
    e = 7

    for ( i=0, i < #aresult.result, i++ ) {
        powReq.base = aresult.result[i];
        powReq.exponent = e;
        pow@Math( powReq )( powResult )
        aresult.result[i] = powResult % n
    }
}

main {
    
    x = true;
    while ( x == true ) {
        
        registerForInput@Console()();
  
        println@Console("Inserisci un messaggio: ")();
        in(a);
        if ( a == "esci") {
            x = false
        }
        a.length = 1;
        splitByLength@StringUtils( a )( aresult );
        //valueToPrettyString@StringUtils( aresult )( result )

        stringToNumber

        for ( i = 0, i < #aresult.result, i++ ) {
            print@Console( aresult.result[i] )(  )
        }

        encryptionRSA

        for ( i = 0, i < #aresult.result, i++ ) {
            println@Console( aresult.result[i] )(  )
        }

        println@Console( result )(  )
        println@Console( "vuoi mandare il messaggio? SI/NO " )(  )
        in(b)
        toUpperCase@StringUtils( b )( bresult )
        if ( bresult == "SI" ) {
            println@Console( "Messaggio spedito" )(  )
            with ( f ) {
                .filename = "source.txt"
                .format = "base64"
            }
            readFile@File( f )( content )
            setFileContent@B( content )()
        } else {
            println@Console( "Messaggio non spedito" )(  )
        }
    }
}