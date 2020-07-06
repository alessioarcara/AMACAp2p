type restituzioneChiaviResponse: void {
  .message: string
}

type restituzioneChiaviRequest: void {
  .message: string
}

interface ShaAlgorithmServiceInterface {
  RequestResponse:
    restituzioneChiavi( restituzioneChiaviRequest )( restituzioneChiaviResponse )
}