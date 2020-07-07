type user: void {
    .name: string
    .port: int
}

type message: void {
    .username: string
    .text: string
}

interface interfacciaB {
    OneWay: broadcast(user),
    RequestResponse: sendStringhe( message )( string ),
    RequestResponse: sendAck( string )( string ),
    RequestResponse: sendInfo( string )( void )
}

