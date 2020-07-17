type HashMessageRequest: void {
  .message: string
}

type HashMessageResponse: void {
  .message: string
}

interface ShaAlgorithmServiceInterface {
  RequestResponse:
    ShaPreprocessingMessage( HashMessageRequest )( HashMessageResponse )
}