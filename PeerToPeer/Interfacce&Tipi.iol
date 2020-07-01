interface firstInterface {
    RequestResponse: sendString( string )( string )
}

type subscribeSessionListener: void {
    .token: string
}

type UnsubscribeSessionListener: void {
    .token: string
}