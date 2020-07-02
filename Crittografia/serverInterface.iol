type sendStringheRequest: void {
  .message: string
  .publickey: string
}

interface ServerInterface {
    
    RequestResponse: 
        sendStringhe( sendStringheRequest )( string )

}