type DecryptedMessageRequest: void {
  .message: string
  .privatekey: string
  .publickey1: string
}

type ShaMessageRequest: void {
  .plaintext: string
  .hashcriptato: string
  .publickey1: string
  .publickey2: string
}

type ShaMessageResponse: void{
  .hashcriptato: string
}

type DecryptedMessageResponse: void {
  .message: string
}

interface DecryptingServiceInterface {
  RequestResponse:
    Decodifica_RSA( DecryptedMessageRequest )( DecryptedMessageResponse )
  RequestResponse:
    Decodifica_SHA( ShaMessageRequest )( ShaMessageResponse )
}
