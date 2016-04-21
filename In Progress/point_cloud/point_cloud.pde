import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

int total = 10;
int [] x = new int[total];
int [] y = new int[total];
int [] z = new int[total];

PeasyCam cam;
Points [] p;

void setup() {
  size(600, 600, P3D);
  background(0);
  stroke(255);
  cam = new PeasyCam(this, 10);
  p = new Points[total];
  for (int i = 0; i < total; i++) {
    p[i] = new Points();
  }
}

void draw() {
  background(0);
  noFill();
  box(30);
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

