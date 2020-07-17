type DecryptedMessageRequest: void {
  .message: string
  .publickey1: string
  .pub_priv_key: string
  .cripto_bit: int
}

type DecryptedMessageResponse: void {
  .message: string
}

interface DecryptingServiceInterface {
  RequestResponse:
    Decodifica_RSA( DecryptedMessageRequest )( DecryptedMessageResponse )
}
