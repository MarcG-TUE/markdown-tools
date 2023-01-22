// https://codepen.io/amybrowndesign/pen/KNXvQm?editors=1111

// function getOneEm(el) {
//   if($(el).find(".fit-em-calculation").length==0) {
//     $(el).prepend('<div class="fit-em-calculation" style="width: 1em;position: absolute;"></div>');
//   }
//   return parseInt($(el).parent().find('.fit-em-calculation').css('width'));
// }



function scaleToFit(el) {

  $(el).find('.fit').each(function () {
    if ($(this).is("h1")) {
      // var em = getOneEm($(this))
      // console.log(`Em: ${em}`)

      // wrap inner if it does not yet exist
      var h1el = $(this);
      if (h1el.find('.fit-inner').length==0){
        h1el.wrapInner('<span class="fit-inner"></span>');        
      }
      var inner = h1el.find('.fit-inner');
      // inner.css('font-size', '1em');
      // console.log(`innerWidth at 1em: ${inner.css('width')}`)
      // inner.css('font-size', '50em');
      // console.log(`innerWidth at 50em: ${inner.css('width')}`)
      // inner.css('font-size', '0.05em');
      // console.log(`innerWidth at 0.05em: ${inner.css('width')}`)
      inner.css('font-size', '0.2em');
      // console.log(`innerWidth at 0.2em: ${inner.css('width')}`)

      var innerWidthFifthEm = parseInt(inner.css('width'));
      var h1Width = parseInt(h1el.css('width'));
      // console.log(`H1 Width: ${h1el.css('width')}`)
      // console.log(`innerWidth at 1em: ${inner.css('width')}`)

      var factor = 0.199 * h1Width / innerWidthFifthEm;

      if (factor > 1) { factor = 1 }
      inner.css('font-size', factor + 'em');
    }
  });
};

Reveal.on('slidechanged', event => {
  // event.previousSlide, event.currentSlide, event.indexh, event.indexv
  scaleToFit(event.currentSlide)
});
