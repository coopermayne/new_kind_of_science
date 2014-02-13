$(document).ready(function() {

  var width = $(document).width();
  var height = $(document).height();

  if (width>height) {
    var rad = height;
  } else {
    var rad = width;
  }

  //$('.circle').css('width', rad);
  //$('.circle').css('height', rad);
  //$('#projects').addClass('left');
  //$('#about').addClass('center');
  //$('#contact').addClass('right');

  $('.container').css('width', rad);
  $('#about').addClass('center');
  $('.circle').css('width', rad);
  $('.circle').css('height', rad);

  $('#menu').css('height', rad/5)

});
