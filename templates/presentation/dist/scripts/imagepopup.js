$(document).ready(function () {

    $(".zoom-image").click(function(){
        // $("#show_image_popup").fadeIn();
        var src_value = $(this).attr('src');
        // console.log(src_value)
        $(".large-image").attr('src',src_value);
        $("#show_image_popup").css('display', 'flex')
        // $("#show_image_popup").show()
    })

    $(".large-image").click(function(){
        $("#show_image_popup").hide()
    })


    $("#close-btn").click(function(){
        $("#show_image_popup").hide()
    })

    $("#close-btn").each(function(){
        // $("#show_image_popup").fadeOut()
        $(this).click(function() {
            $("#show_image_popup").hide()
        })
    })

})