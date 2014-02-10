//make a grid of arbitrary dimentions fill the screen
//
$(document).ready(function() {

  $('#status').text('fetching data');
  console.log('fetching data');
  $.ajax({
    url: "http://localhost:3000/json"
  }).done(function(x) {
    $('#status').text('building graphic');
    console.log('building graphic');
    display(x);
  });

});

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
  //$.each(json, function( key, row ) {
    //var r = $('<tr></tr>')
    //r.height(box_length)


    ////generate the columns in this row
    //var stringy = $.map(row, function(k,col){
      ////var box = $('<div class="box"></div>');

      //var color = 'grey';
      //if (col==1) {
        //color = 'black';
      //};

      //return '<td class="box" style="width:' + box_length + '; height: '+box_length+'; background-color: '+color+';"></td>';

    //});
    ////end

    //row_html = stringy.join("");
    //r.append(row_html);

    //plug.append(r)
  //});

  //$('body').append(plug)
  //var table = $('<table></table>');
};
