type DecryptedMessageRequest: void {
  .message: string
}

type DecryptedMessageResponse: void {
  .reply: string
}

interface EncryptingServiceInterface {
  RequestResponse:
    DecryptedMessage( DecryptedMessageRequest )( DecryptedMessageResponse )
}
