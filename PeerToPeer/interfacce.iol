type username: void {
    .name: string
    .port: int
}

type message: void {
    .username: string
    .text: string
}

/* interface IController {
    RequestResponse: setCount( string )( int ),
    RequestResponse: getCount( string )( int ),
    RequestResponse: setUsername( username )( bool ),
    RequestResponse: getUserPort( string )( int )
} */

interface interfacciaB {
    RequestResponse: sendStringhe( message )( string ),
    RequestResponse: sendAck( string )( string ),
    RequestResponse: sendInfo( string )( void ),
    RequestResponse: changePort( int )( void )
}

