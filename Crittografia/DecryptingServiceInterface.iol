type DecryptedMessageRequest: void {
  .message: string
}

type DecryptedMessageResponse: void {
  .reply: string
}

interface DecryptingServiceInterface {
  RequestResponse:
    DecryptedMessage( DecryptedMessageRequest )( DecryptedMessageResponse )
}
