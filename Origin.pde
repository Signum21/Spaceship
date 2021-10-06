ArrayList <Triangle> trail = new ArrayList <Triangle>();
ArrayList <Line> shortLines = new ArrayList <Line>();
ArrayList <Line> mediumLines = new ArrayList <Line>();
ArrayList <Line> longLines = new ArrayList <Line>();
PGraphics pgShortMediumLines, pgLongLines, pgMask;
TriangleHoled bigTriangle;
Triangle smallTriangle;
int state = 1, counter = 0;

void setup() {
  size(500, 500);
  noStroke();
  frameRate(200);

  for (int a = 0; a < 50; a++) {
    shortLines.add(new Line(random(0, width), random(0, height), 40));
  }

  for (int a = 0; a < 35; a++) {
    mediumLines.add(new Line(random(0, width), random(0, height), 80));
  }

  for (int a = 0; a < 20; a++) {
    longLines.add(new Line(random(0, width), random(0, height), 120));
  }
  bigTriangle = new TriangleHoled(width/2, 25, 950, height/2, 150);
  smallTriangle = new Triangle(width/2, height/2, 150);
  pgShortMediumLines = createGraphics(width, height);
  pgLongLines = createGraphics(width, height);
  pgMask = createGraphics(width, height);

  pgLongLines.beginDraw();
    pgLongLines.stroke(150, 100, 100);
  pgLongLines.endDraw();
}

void draw() {
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

void moveShortMediumLines(){
  pgShortMediumLines.beginDraw();
    pgShortMediumLines.background(255, 200, 200);

    pgShortMediumLines.stroke(200, 150, 150);
    moveLines(shortLines, pgShortMediumLines, 15, 40, 1);

    pgShortMediumLines.stroke(255);
    moveLines(mediumLines, pgShortMediumLines, 20, 80, 2);
  pgShortMediumLines.endDraw();
}

void moveLongLines(){
  pgLongLines.beginDraw();
    pgLongLines.background(50);

    moveLines(longLines, pgLongLines, 25, 120, 3);
  pgLongLines.endDraw();
}

void moveLines(ArrayList<Line> lines, PGraphics background, int frequency, int len, int vel){
  if (frameCount % frequency == 0) {
    lines.add(new Line(random(0, width), -(len + 10), len));
  } 

  for (int a = lines.size()-1; a >= 0; a--) { 
    lines.get(a).displayInside(background);
    lines.get(a).goDown(vel);
    
    if (lines.get(a).isOut(height)) {
      lines.remove(a);
    }
  }
}

void show(PGraphics backgroundLines, PGraphics foregroundLines, color small, color big){
  image(backgroundLines, 0, 0);

  fill(small);
  smallTriangle.display();
  fill(big);
  bigTriangle.display();
  
  foregroundLines.beginDraw();
    foregroundLines.mask(bigTriangle.createMask(pgMask));
  foregroundLines.endDraw();
  image(foregroundLines, 0, 0);
}

void moveExternalTriangle(){
  if (counter > 135) {
    bigTriangle.goDown(15);

    if (bigTriangle.isOut(height)) {
      state += 1;
      counter = 0;
      bigTriangle.reset();
    }
  }
}

void moveInternalTriangles(){
  float mSpeed;
  final int distance = 100, speed = 5;

  if (counter <= distance) {
    mSpeed = map(counter, 1, distance, speed, 1);
    smallTriangle.goDown(mSpeed+1);
    bigTriangle.goDownB(mSpeed+1);
  } 
  else if (counter > distance && counter < distance*2) {
    mSpeed = map(counter, distance, distance*2, 1, speed);
    smallTriangle.goUp(mSpeed);
    bigTriangle.goUpB(mSpeed);
  } 
  else {
    bigTriangle.goUpB(1); 
    smallTriangle.goUp(1);
    mSpeed = 0;
    counter = 0;
    state = (state+1)%4;
  }
  counter += mSpeed;
}

void showTrail(){
  for (int a = trail.size()-1; a >= 0; a--) {
    fill(255, 200, 200, height-trail.get(a).y1);
    trail.get(a).display();
    trail.get(a).reduceH(1);
    trail.get(a).goDown(5);
  
    if (trail.get(a).isOut(height) || !bigTriangle.contains(trail.get(a).y1)){
      trail.remove(a);
    }
  }
  
  if(state == 3 && counter % 20 == 1 && bigTriangle.y1 < bigTriangle.yb1) {
    trail.add(new Triangle(width/2, bigTriangle.getCenterYB1(), 140));
  }
}
