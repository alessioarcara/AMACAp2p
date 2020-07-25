include "console.iol"
include "semaphore_utils.iol"

define p1 {
    acquire@SemaphoreUtils( semaphoreOne )() 
            x = x + 10
    release@SemaphoreUtils( semaphoreOne )()
}

define p2 {
    acquire@SemaphoreUtils( semaphoreOne )() 
            x = x - 10
    release@SemaphoreUtils( semaphoreOne )()
}

main {
    semaphoreOne.name = "semaphoreOne"
    semaphoreOne.permits = 1

    release@SemaphoreUtils( semaphoreOne )();

    for( i = 0, i < 10, i++ ) {

        x = 100;

        {   p1 | p2 };

        print@Console( x + " " )()
    }
    println@Console()()
}