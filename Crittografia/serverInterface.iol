type sendStringheRequest: void {
  .message: string
}

type FirmaDigitaleRequest: void {
  .plaintext: string
  .message: string
  .publickey1: string
  .publickey2: string
}

type scambioChiaviRequest: void {
  .publickey1: string
  .publickey2: string
}

type scambioChiaviResponse: void {
  .publickey1: string
  .publickey2: string
}

interface ServerInterface {
    RequestResponse: 
        sendStringhe( sendStringheRequest )( void )
    RequestResponse: 
        sendStringhePubblico( FirmaDigitaleRequest )( void )
}

interface scambioChiaviInterface {

  RequestResponse: 
      scambioChiavi ( scambioChiaviRequest ) ( scambioChiaviResponse )
}