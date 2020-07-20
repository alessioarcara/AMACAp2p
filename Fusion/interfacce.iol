///////////////////////// TYPE /////////////////////////

type user: void {
    .name: string
    .port: int
}

type message: void {
    .username: string
    .text: string
}

type messageGroup: void {
    .username: string
    .text: string
    .message: string
    .publickey1: string
    .publickey2: string
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

type chiaviPersonali: void {
    .publickey1: string
    .publickey2: string
    .privatekey: string
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
    RequestResponse: richiestaProprieChiavi( void )( chiaviPersonali )
}

interface IGroup {
    RequestResponse: setGroup(group)(void),
    OneWay: sendMessage( messageGroup ),
    OneWay: verify(void),
    OneWay: forwardMessage( messageGroup ),
    RequestResponse: enterGroup(user)(void),
    RequestResponse: exitGroup(user)(void)
}

interface ISwing {
  RequestResponse: aperturaMenu( string )( int )
}