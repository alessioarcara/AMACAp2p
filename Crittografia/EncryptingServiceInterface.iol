type EncryptedMessageRequest: void {
  .message: string
  .publickey1: string
  .publickey2: string
  .privatekey: string
}

type EncryptedMessageResponse: void {
  .reply: string
}

interface EncryptingServiceInterface {
  RequestResponse:
    EncryptedMessage( EncryptedMessageRequest )( EncryptedMessageResponse )
}
