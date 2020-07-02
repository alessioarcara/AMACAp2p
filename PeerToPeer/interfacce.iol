type username: void {
    .name: string
    .port: int
}

interface IController {
    RequestResponse: setCount( string )( int ),
    RequestResponse: getCount( string )( int ),
    RequestResponse: setUsername( username )( bool ),
    RequestResponse: getUserPort( string )( int )
}

interface interfacciaB {
    RequestResponse: sendStringhe( string )( string ),
    RequestResponse: sendAck( string )( string ),
    RequestResponse: sendInfo( string )( void )
}

interface IUserMonitor {
    RequestResponse: findUser( string )( bool )
}
