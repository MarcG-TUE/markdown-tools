// https://codepen.io/amybrowndesign/pen/KNXvQm?editors=1111

// Calculate width of text from DOM element or string. By Phil Freo <http://philfreo.com>
$.fn.textWidth = function(text, font) {
  if (!$.fn.textWidth.fakeEl) $.fn.textWidth.fakeEl = $('<span>').hide().appendTo(document.body);
  $.fn.textWidth.fakeEl.text(text || this.val() || this.text()).css('font', font || this.css('font'));
  return $.fn.textWidth.fakeEl.width();
};

function scaleToFit() {

    $('.fit').each(function(){
      if ($(this).is("h1")) {
        console.log("Fit")

        console.log($(this).css('width'))

        $(this).parent().prepend('<div class="fit-em-calculation" style="width: 1em;position: absolute;"></div>');
        var em = parseInt($('.fit-em-calculation').css('width'));
        // console.log(`Em: ${em}`)
        // console.log(`Em: ${$('.fit-em-calculation').css('width')}`)
    
        // $(this).wrapInner('<span></span>');
        $(this).wrapInner('<span class="fit-inner"></span>');
        var el = $(this);
        var inner = el.find('.fit-inner');
        // var fitWidth = parseInt(el.css('width'));
        var innerWidth = parseInt(inner.css('width'));
        // console.log(`fitWidth: ${fitWidth}`)
        console.log(`innerWidth: ${innerWidth}`)
        
        // the magic number of 907...
        if (innerWidth == 907) {

          // don't know the right scaling...
          // var factor = fitWidth / innerWidth;
          var factor = 1.0;
          var calc = em * factor;
          console.log(`factor: ${factor}`)

          $(this).css('font-size', calc + 'px');
          $(this).css('display', 'block');
        }
      }
    });
};

window.onload = function(event) {
    scaleToFit();
};
window.onresize = function(event) {
    scaleToFit();
};