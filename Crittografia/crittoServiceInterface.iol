type encryptingRequest: void {
  .message: string
}

type encryptingResponse: void {
  .reply: string
}

interface CrittoServiceInterface {
  RequestResponse:
    encrypting( encryptingRequest )( encryptingResponse )
}