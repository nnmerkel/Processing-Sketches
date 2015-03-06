float x;
float y;
int totalPoints = 20;
int innerPoints = 100;
int mappedPoints;
float radius = 200;
float angle;
int angleStep;

Point [] p;

void setup() {
  size(800, 800);
  x = width/2;
  y = height/2;
  p = new Point[innerPoints];
  for (int i = 0; i < innerPoints; i++) {
    p[i] = new Point();
  }
}

void draw() {
  noStroke();
  fill(205);
  rect(0, 0, width, height);
  stroke(0);
  strokeWeight(1);
  staticShape();
  for (int i = 0; i < innerPoints; i++) {
    p[i].run();
    float xIndex = 0;
    float yIndex = 0;
    p[i].getCoordinates(xIndex, yIndex);
  }
}

//cool tool, but not pertinent for this sketch
void dynamicShape() {
  mappedPoints = int(map(mouseX, 0, width, 3, 30));
  angle = 0;
  angleStep = 360/mappedPoints;

  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < totalPoints; i++) {
    float px = x + cos(radians(angle)) * radius;
    float py = y + sin(radians(angle)) * radius;
    vertex(px, py);
    angle += angleStep;
  }
  endShape(CLOSE);
}

//stationary shape that will contain the points and be triangulated
void staticShape() {
  noFill();
  angleStep = 360/totalPoints;
  beginShape();
  for (int i = 0; i < totalPoints; i++) {
    float px = x + cos(radians(angle)) * radius;
    float py = y + sin(radians(angle)) * radius;
    vertex(px, py);
    angle += angleStep;
  }
  endShape(CLOSE);
}

void keyReleased() {
  if (key == 's' || key == 'S') {
    saveFrame();
    println("saved");
  }
}

