var trail, shortLines, mediumLines, longLines; //[]
var pgShortMediumLines, pgLongLines, pgMask; //pg
var bigTriangle, smallTriangle;
var state, counter;

function initializeFields() {
    trail = []; 
    shortLines = []; 
    mediumLines = []; 
    longLines = [];
    state = 1;
    counter = 0;
}

function setup() {
  initializeFields();
  createCanvas(500, 500);
  noStroke();

  for (let a = 0; a < 50; a++) {
    shortLines.push(new Line(random(0, width), random(0, height), 40));
  }

  for (let a = 0; a < 35; a++) {
    mediumLines.push(new Line(random(0, width), random(0, height), 80));
  }

  for (let a = 0; a < 20; a++) {
    longLines.push(new Line(random(0, width), random(0, height), 120));
  }
  bigTriangle = new TriangleHoled(width/2, 25, 950, height/2, 150);
  smallTriangle = new Triangle(width/2, height/2, 150);
  pgShortMediumLines = createGraphics(width, height);
  pgLongLines = createGraphics(width, height);
  pgMask = createGraphics(width, height);
  pgLongLines.stroke(150, 100, 100);
}

function draw() {
  switch(state){
    case 1:
      moveShortMediumLines();
      moveLongLines();
      show(pgLongLines, pgShortMediumLines, color(50), color(255, 200, 200));
      moveExternalTriangle();
      break;
      
    case 2:
      moveLongLines();
      show(pgShortMediumLines, pgLongLines, color(255, 200, 200), color(50));
      moveInternalTriangles();
      break;

    case 3:
      moveShortMediumLines();
      moveLongLines();
      show(pgShortMediumLines, pgLongLines, color(255, 200, 200), color(50));
      moveExternalTriangle();
      break;

    case 4:
      moveShortMediumLines();
      show(pgLongLines, pgShortMediumLines, color(50), color(255, 200, 200));
      moveInternalTriangles();
      break;
  }
  showTrail();
  counter++;
}

function moveLines(lines, background, frequency, len, vel){
  if (frameCount % (int(frequency/4)) == 0) {
    lines.push(new Line(random(0, width), -(len + 10), len));
  } 

  for (let a = lines.length-1; a >= 0; a--) { 
    lines[a].displayInside(background);
    lines[a].goDown(vel*4);
    
    if (lines[a].isOut(height)) {
      lines.splice(a, 1);
    }
  }
}

function moveShortMediumLines(){
  pgShortMediumLines.background(255, 200, 200);  

  pgShortMediumLines.stroke(200, 150, 150);
  moveLines(shortLines, pgShortMediumLines, 15, 40, 1);  

  pgShortMediumLines.stroke(255);
  moveLines(mediumLines, pgShortMediumLines, 20, 80, 2);
}

function moveLongLines(){
  pgLongLines.background(50);

  moveLines(longLines, pgLongLines, 25, 120, 3);
}

function show(backgroundLines, foregroundLines, small, big){
  image(backgroundLines, 0, 0);

  fill(small);
  smallTriangle.display();
  fill(big);
  bigTriangle.display();
  
  let masked = foregroundLines.get();
  masked.mask(bigTriangle.createMask(pgMask));
  image(masked, 0, 0);
}

function showTrail(){
  for (let a = trail.length-1; a >= 0; a--) {
    fill(255, 200, 200, height-trail[a].y1);
    trail[a].display();
    trail[a].reduceH(1);
    trail[a].goDown(5*4);
  
    if (trail[a].isOut(height) || !bigTriangle.contains(trail[a].y1)){
      trail.splice(a, 1);
    }
  }
  
  if(state == 3 && counter % (20/4) == 1 && bigTriangle.y1 < bigTriangle.yb1) {
    trail.push(new Triangle(width/2, bigTriangle.getCenterYB1(), 140));
  }
}

function moveExternalTriangle(){
  if (counter > (135/4)) {
    bigTriangle.goDown(15*4);

    if (bigTriangle.isOut(height)) {
      state += 1;
      counter = 0;
      bigTriangle.reset();
    }
  }
}

function moveInternalTriangles(){
  let mSpeed;
  const distance = 100, speed = 5;

  if (counter <= distance) {
    mSpeed = map(counter, 1, distance, speed, 1)*4;
    smallTriangle.goDown(mSpeed);
    bigTriangle.goDownB(mSpeed);
  } 
  else if (counter > distance && counter < distance*2) {
    mSpeed = map(counter, distance, distance*2, 1, speed)*4;
    smallTriangle.goUp(mSpeed);
    bigTriangle.goUpB(mSpeed);
  } 
  else {
    bigTriangle.goUpB(3.57); 
    smallTriangle.goUp(3.57);
    mSpeed = 0;
    counter = 0;
    state = (state+1)%4;
  }
  counter += mSpeed;
}