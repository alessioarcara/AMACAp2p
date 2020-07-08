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
    OneWay: broadcast(user),
    RequestResponse: getPeerName(void)(users),
    RequestResponse: getPeerPort(void)(users),
    RequestResponse: getUsers(void)(users),
    RequestResponse: sendStringhe( message )( string ),
    RequestResponse: sendAck( string )( string ),
    RequestResponse: sendInfo( string )( void )
}

interface teniamoTraccia {
    RequestResponse: press( string )( void )
}