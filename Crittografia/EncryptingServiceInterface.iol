type EncryptedMessageRequest: void {
  .message: string
  .publickey1: string
  .pub_priv_key: string
  .cripto_bit: int
}

type EncryptedMessageResponse: void {
  .message: string
}

interface EncryptingServiceInterface {
  RequestResponse:
    Codifica_RSA( EncryptedMessageRequest )( EncryptedMessageResponse )
}
