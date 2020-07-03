type sendStringheRequest: void {
  .message: string
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
        sendStringhe( sendStringheRequest )( string )

}

interface scambioChiaviInterface {

  RequestResponse: 
      scambioChiavi ( scambioChiaviRequest ) ( scambioChiaviResponse )
}