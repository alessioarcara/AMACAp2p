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

type group: void {
    .name: string
    .port: int
}

type scambioChiaviRequest: void {
  .publickey1: string
  .publickey2: string
}

type scambioChiaviResponse: void {
  .publickey1: string
  .publickey2: string
}


///////////////////////// INTERFACES /////////////////////////

interface teniamoTraccia {
    RequestResponse: press( string )( void )
}

interface interfacciaB {
    OneWay: broadcast( user ),
    RequestResponse: searchPeer( string )( int ),
    OneWay: hello( user ),
    RequestResponse: getCount( void )( int ),
    RequestResponse: sendStringhe( message )( string ),
    RequestResponse: sendInfo( user )( void ),
    RequestResponse: chatRequest( string )( bool ),
    RequestResponse: infoUser( void )( string ),
    RequestResponse: richiestaChiavi( void )( scambioChiaviRequest )
    // RequestResponse: verifyGroup( group )( bool ),
    // OneWay: addGroup( group )
}

interface IGroup {
    RequestResponse: verifyGroup( string )( bool ),
    OneWay: addGroup( string )
}