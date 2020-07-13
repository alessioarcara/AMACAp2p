include "console.iol"
include "interfacce.iol"

inputPort GroupPort {
    Location: LOCATION
    Protocol: http
    Interfaces: IGroup, interfacciaB
}

outputPort out {
    Protocol: http
    Interfaces: interfacciaB, IGroup
}

outputPort portaStampaConsole {
    Location: "socket://localhost:30000"
    Protocol: http
    Interfaces: teniamoTraccia
}

init {
    global.group.name = ""
    global.group.port = 0
}

main {

    //inizializza nome e porta del gruppo
    [
        setGroupName(request)() {
            global.group.name = request.name
            global.group.port = request.port
        }
    ]

    //BROADCAST
    [broadcast( newuser )] {
        out.location = "socket://localhost:" + newuser.port
        hello@out( global.group )
    }

    


}
