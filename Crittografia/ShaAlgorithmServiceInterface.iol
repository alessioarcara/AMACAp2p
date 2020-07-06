type HashMessageResponse: void {
  .message: string
}

type HashMessageRequest: void {
  .message: string
}

interface ShaAlgorithmServiceInterface {
  RequestResponse:
    ShaPreprocessingMessage( HashMessageRequest )( HashMessageResponse )
}