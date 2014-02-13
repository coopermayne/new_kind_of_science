//make a grid of arbitrary dimentions fill the screen
var json;
//
$(document).ready(function() {
  setHandlers()
});

function setHandlers () {

  $('form').on('submit', function(e) {
    e.preventDefault();
    width = $('input[name=width]')[0].value
    height = $('input[name=height]')[0].value
    fetchDataAndDisplay(width,height);
  })
}

function fetchDataAndDisplay(width, height) {
  console.log('fetching data');
  $.ajax({
    url: "http://localhost:3000/json?" + "height=" + height + "&width=" + width
  }).done(function(data) {
    console.log('building graphic');
    $('#generated').html("<img src='" + data + "'>")
    //display(data);
    //displayPng(data)
  });
}

function displayPng (json) {
  var rows = json.length
  var cols = json[0].length
  js = json;

  Caman.Filter.register("science", function () {

    // Our process function that will be called for each pixel.
    // Note that we pass the name of the filter as the first argument.

    this.process("science", function (rgba) {


      xCoord = this.locationXY().x
      yCoord = 501-this.locationXY().y

      if(js[yCoord][xCoord] == 1){
        rgba.r = 0
        rgba.g = 0
        rgba.b = 0
      }

      // Return the modified RGB values
      return rgba;
    });
  });
  
  Caman("#canvas", "501.png", function () {
    // manipulate image here
    this.science();
    this.render();
  });

};

function display (json) {
  var rows = json.length
  var cols = json[0].length
  var height = $(document).height() - 30;
  var box_length = height/rows;
  $('head').append('<style>.box{width:'+box_length+'px;height:'+box_length+'px;background-color:grey;}</style>')

  //make a big html string and add it all at once....
  
  var inside = "";

  for (var i = 0; i < json.length; i++) {
    var inner = "";
    for (var j = 0; j < json[i].length; j++) {
      if (json[i][j]==1) {
        var bg = 'style="background-color:black"';
      }else{
        var bg = "";
      };
      inner = inner.concat('<td class="box"'+ bg +'></td>')
    };
    inside = inside.concat('<tr>' + inner + '</tr>');
  };
  $('body').append('<table>'+inside+'</table>');
};
