#!/bin/bash

#variabili inizializzazione
pwd=`pwd`
count=2

#apertura console localhost
echo "Apertura ConsoleStampa ..."
osascript -e 'tell app "Terminal"
    activate
    do script "cd '$pwd'" in window 1
    do script "jolie ConsoleStampa.ol" in window 1
end tell'

#apertura automatica peers localhost
echo "Inserisci il numero dei Peer da aprire:"
read n
for ((i = 0; i < n; i++ ))
do 
    echo -e "Apertura PeerAA $count ..."
        osascript -e 'tell app "Terminal"
        activate
        do script "cd '$pwd'" # in front window
        delay 1
        do script "jolie PeerAA.ol" in front window
    end tell'
    count=$((count + 1))
done