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
    RequestResponse: sendInfo( user )( void ),
    RequestResponse: chatRequest( string )( bool )
}

interface teniamoTraccia {
    RequestResponse: press( string )( void )
}