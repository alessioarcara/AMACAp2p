type scambioChiaviRequest: void {
  .publickey1: string
  .publickey2: string
}

type scambioChiaviResponse: void {
  .publickey1: string
  .publickey2: string
}

interface scambioChiaviInterface {
  RequestResponse: scambioChiavi ( scambioChiaviRequest ) ( scambioChiaviResponse )
}