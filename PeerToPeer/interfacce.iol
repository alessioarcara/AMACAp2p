type user: void {
    .name: string
    .port: int
}

type message: void {
    .username: string
    .text: string
}

type users: any {?}

interface interfacciaB {
    OneWay: broadcast( user ),
    RequestResponse: searchPeer(string)(int),
    OneWay: hello(user),
    RequestResponse: getCount(void)(int),
    RequestResponse: sendStringhe( message )( string ),
    RequestResponse: sendAck( string )( string ),
    RequestResponse: sendInfo( user )( void )
}

interface teniamoTraccia {
    RequestResponse: press( string )( void )
}