type DecryptedMessageRequest: void {
  .message: string
  .privatekey: string
  .publickey1: string
}

type DecryptedMessageResponse: void {
  .message: string
}

interface DecryptingServiceInterface {
  RequestResponse:
    DecryptedMessage( DecryptedMessageRequest )( DecryptedMessageResponse )
}
