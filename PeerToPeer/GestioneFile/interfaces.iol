type richiesta: void {
    .first: int
    .second: int
}

type doubleFile: void {
    .first: string
    .second: string
}

interface INumber {
    RequestResponse: invioNumero( richiesta )( int )
}

interface ServerInterface {
    RequestResponse: setFileContent( doubleFile )( void )
}