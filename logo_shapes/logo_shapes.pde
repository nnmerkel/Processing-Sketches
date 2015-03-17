import processing.pdf.*;

boolean record;

int totalPoints = 20;
int innerPoints = 30;
int mappedPoints;
float radius = 300;
float angle;
int angleStep;
float lineDistance = 200;
float strokeWeight = 5;

Point [] p;

void setup() {
  size(800, 800);
  //initialize points
  p = new Point[innerPoints];
  for (int i = 0; i < innerPoints; i++) {
    p[i] = new Point();
  }
}

void draw() {
  if (record) beginRecord(PDF, "logo_####.pdf");

  //redraw background
  noStroke();
  fill(0);
  rect(0, 0, width, height);

  //draw the shape and render the points
  stroke(30, 131, 216, 100);
  strokeWeight(1);
  pushMatrix();
  translate(width/2, height/2);
  staticShape();
  for (int i = 0; i < innerPoints; i++) {
    for (int j = 0; j < innerPoints; j++) {
      p[i].run();
      p[j].run();
      float d = dist(p[i].location.x, p[i].location.y, p[j].location.x, p[j].location.y);
      if (d <= lineDistance) {
        float opacityMap = map(d, 0, lineDistance, 255, 0);
        stroke(30, 131, 216, opacityMap);
        strokeWeight(1);
        line(p[i].location.x, p[i].location.y, p[j].location.x, p[j].location.y);
      }
    }
  }
  popMatrix();
  if (record) {
    endRecord();
    record = false;
    println("pdf saved");
  }
}

//maps the shapes faceting to mouseX, so its cool but it would look funny
void dynamicShape() {
  mappedPoints = int(map(mouseX, 0, width, 3, 30));
  angle = 0;
  angleStep = 360/mappedPoints;
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < totalPoints; i++) {
    float px = cos(radians(angle)) * radius;
    float py = sin(radians(angle)) * radius;
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
    float px = cos(radians(angle)) * radius;
    float py = sin(radians(angle)) * radius;
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
  if (key == 'p'|| key == 'P') {
    record = true;
  }
}

