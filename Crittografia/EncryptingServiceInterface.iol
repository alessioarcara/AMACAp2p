type EncryptedMessageRequest: void {
  .message: string
  .publickey1: string
  .publickey2: string
}

type EncryptedMessageResponse: void {
  .message: string
}

interface EncryptingServiceInterface {
  RequestResponse:
    Codifica_RSA( EncryptedMessageRequest )( EncryptedMessageResponse )
}
