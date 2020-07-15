///////////////////////// TYPE /////////////////////////

type user: void {
    .name: string
    .port: int
}

type message: void {
    .username: string
    .text: string
}

type users: any {?}

type richiestaChiaviResponse: void {
    .publickey1: string
    .publickey2: string
}

type group: void {
    .name: string
    .port: int
    .host: int
}


///////////////////////// INTERFACES /////////////////////////

interface teniamoTraccia {
    RequestResponse: press( string )( void )
}

interface interfacciaB {
    OneWay: broadcast( int ),
    RequestResponse: login(int)(string),
    RequestResponse: searchPeer( string )( int ),
    OneWay: hello( user ),
    OneWay: sendHi( user ),
    RequestResponse: getCount( void )( int ),
    RequestResponse: sendStringhe( message )( string ),
    RequestResponse: chatRequest( string )( bool ),
    RequestResponse: richiestaChiavi( void )( richiestaChiaviResponse ),
    OneWay: generateKey( void )
}

interface IGroup {
    RequestResponse: setGroup(group)(void),
    OneWay: sendMessage(message),
    OneWay: verify(void),
    OneWay: forwardMessage(message),
    RequestResponse: enterGroup(user)(void),
    RequestResponse: exitGroup(user)(void)
}