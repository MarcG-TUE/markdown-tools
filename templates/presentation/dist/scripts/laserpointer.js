$(document).ready(function () {

    var laserOn = false

    $("body").keydown(function(event){
        // letter l
        if ( event.which == 76 ) {
            if (laserOn) {
                $("body").css( "cursor", "default" )
                laserOn = false
                event.stopPropagation()
            } else {
                $("body").css( 
                    {"cursor": "url(./styles/images/laser.png),default"} )
                laserOn = true
                event.stopPropagation()
            }
        }
    })
})