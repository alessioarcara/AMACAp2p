type restituzioneChiaviResponse: void {
  .publickey1: string
  .publickey2: string
  .privatekey: string
}

interface KeyGeneratorServiceInterface {
  RequestResponse:
    restituzioneChiavi( void )( restituzioneChiaviResponse )
}