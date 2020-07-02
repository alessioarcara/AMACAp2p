include "console.iol"

interface interfacciaC {
    RequestResponse: setCount( string )( int ),
    RequestResponse: getCount( string )( int )
}

inputPort controllerPort {
    Location: "socket://localhost:9999" 
    Protocol: http
    Interfaces: interfacciaC
}

init {
    counter = 1
}

main {

    [
        setCount(request)(response) {
            counter = counter + 1
            response = counter
        }
    ]

    [
        getCount(request)(response) {
            response = counter
        }
    ]

}