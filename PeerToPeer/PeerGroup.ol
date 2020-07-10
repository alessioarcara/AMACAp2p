include "console.iol"
include "interfacce.iol"

inputPort GroupPort {
    Location: LOCATION
    Protocol: http
    Interfaces: interfacciaB
}

init {
    global.group.name = "undefined"
}
