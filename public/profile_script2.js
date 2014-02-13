var projects, about, contact, current, foldNumber, foldArray, counter, d, destination, i, defaultSpeed;

function resetNav () {
  console.log('reset nav');
  $('a').on('mouseover', function(e){console.log(e)});
  //$('.projects').on('click', function(e) {
    //cycle(projects);
    //e.stopPropagation();
  //});

  //$('.about').on('click', function(e) {
    //cycle(about);
    //e.stopPropagation();
  //});

  //$('.contact').on('click', function(e) {
    //cycle(contact);
    //e.stopPropagation();
  //});
};


function resetSpeeds () {
  defaultSpeed = 700
  contact.setSpeed(defaultSpeed);
  projects.setSpeed(defaultSpeed);
  about.setSpeed(defaultSpeed);
}

//function showHandCursor () {
  ////show hand cursor on expandable items
  //console.log(foldArray.indexOf(current));
//}

function cycle (destination) {
  console.log([foldArray.indexOf(current), foldArray.indexOf(destination)])

  if (Math.abs(foldArray.indexOf(destination) - foldArray.indexOf(current)) >1 ) {   //need multiple animations
    cycle(foldArray[1])
    setTimeout( function() { cycle(destination) }, 850)
    return
  }

  if (destination==current) {
    console.log('DOING NOTHING');
    return;
  }

  if (foldArray.indexOf(destination) < foldArray.indexOf(current)) {
    direction = "right";
  } else {
    direction = "left";
  }

  destination.accordion(0);

  current.setSpeed(500).accordion(foldNumber, direction, resetSpeeds); //speed up the folding so it syncs with unfolding
  current = destination;
  //showHandCursor();
}

$(document).ready(function() {
  //init slideshow;
  //$('#slideshow').cycle({
    //speed: 600,
    //manualSpeed: 100
  //});

  //set up listeners
  $(window).keydown(function(e) {
    if (performance.now() - counter < 850) {return} //prevent clogging 

    counter = performance.now()
    i = foldArray.indexOf(current)

    if (e.keyCode == 37 && i!==0 ) { //left arrow
      cycle(foldArray[i-1]);
    } else if (e.keyCode == 39 && i !== 2) { //right arrow
      cycle(foldArray[i+1]);
    }
  })

  foldNumber = 82.7
  options = { 
    vPanels: 8,
    touchEnabled: false,
    shadingIntesity: .9
  }

  projects = new OriDomi(document.getElementsByClassName('projects')[0], options);
  about = new OriDomi(document.getElementsByClassName('about')[0], options);
  contact= new OriDomi(document.getElementsByClassName('contact')[0], options);

  foldArray = [projects, about, contact];

  //set up initial focus
  contact.setSpeed(0).accordion(foldNumber, 'right', resetSpeeds);
  projects.setSpeed(0).accordion(foldNumber);
  //showHandCursor();
  resetNav();

  current = about; //we are starting on the middle panel... use this var to keep track...
});
