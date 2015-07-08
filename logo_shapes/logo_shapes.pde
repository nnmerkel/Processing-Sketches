import processing.pdf.*;
import java.util.Calendar;

boolean record;

PImage s;
int shapeSides = 6;
int innerPoints = 90;
int mappedPoints;
int frameCounter;
float radius = 300;
float angle;
int angleStep;
float lineDistance = 180;
float strokeWeight;

Point [] p;

void setup() {
  size(765, 984);
  //s = loadImage("ss-pig.png");
  //initialize points
  p = new Point[innerPoints];
  for (int i = 0; i < innerPoints; i++) {
    p[i] = new Point();
  }
}

void draw() {
  if (record) beginRecord(PDF, timestamp() + ".pdf");

  //redraw background
  noStroke();
  fill(0, 100);
  rect(0, 0, width, height);
  //image(s, 0, 0);

  //draw the shape and render the points
  //stroke(30, 131, 216, 180);
  stroke(242, 118, 48, 180);
  strokeWeight(1);
  pushMatrix();
  //translate(width/2, height/2);
  //staticShape();
  for (int i = 0; i < innerPoints; i++) {
    p[i].run();
    for (int j = 0; j < innerPoints; j++) {
      strokeWeight = random(2, 6);
      float d = dist(p[i].location.x, p[i].location.y, p[j].location.x, p[j].location.y);
      if (d <= lineDistance) {
        float opacityMap = map(d, 0, lineDistance, 255, 0);
        stroke(242, 118, 48, opacityMap);
        //stroke(30, 131, 216, opacityMap);
        strokeWeight(1);
        line(p[i].location.x, p[i].location.y, p[j].location.x, p[j].location.y);
        //stroke(63, 83, 170, 20);
        //line(p[i].location.x, 0, p[i].location.x, height);
        //line(0, p[i].location.y, width, p[i].location.y);
      }
    }
  }
  popMatrix();
  //saveFrame("animation_####.tif");
  //println("frame saved");
  //frameCounter++;
  //if (frameCounter == 300) exit();
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
  for (int i = 0; i < shapeSides; i++) {
    float px = cos(radians(angle)) * radius;
    float py = sin(radians(angle)) * radius;
    vertex(px, py);
    angle += angleStep;
  }
  endShape(CLOSE);
}

//stationary shape that will contain the points and be triangulated
//the first point is ALWAYS (r, 0)
void staticShape() {
  noFill();
  angleStep = 360/shapeSides;
  beginShape();
  for (int i = 0; i < shapeSides; i++) {
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

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

