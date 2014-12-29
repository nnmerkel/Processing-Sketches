import processing.pdf.*;
import controlP5.*;

PImage s;
ControlP5 cp5;
int total = 1000;
int [] x = new int[total];
int [] y = new int[total];
float bigLimit = 0;
float smallLimit = 0;
float smallLowLimit = 2;
float bigLowLimit = 50;
float renderSpeed = 4;
float lineSw = .5;
float pointSw = 2;

void setup() {
  size(1920, 1200);
  s = loadImage("face2.jpg");
  background(255);
  cp5 = new ControlP5(this);
  //cp5.addSlider("total").setPosition(0, 0).setSize(200, 20).setRange(100, 10000).setValue(100);
  cp5.addSlider("smallLimit").setPosition(0, 22).setSize(200, 20).setRange(4, 500);
  cp5.addSlider("renderSpeed").setPosition(0, 44).setSize(200, 20).setRange(1, 60);
  cp5.addSlider("lineSw").setPosition(0, 66).setSize(200, 20).setRange(.5, 3.5).setNumberOfTickMarks(7);
  cp5.addSlider("pointSw").setPosition(0, 88).setSize(200, 20).setRange(.5, 3.5).setNumberOfTickMarks(7);
  //overlayNorm();
  //highlights();
  //points();
  //points2();
}

void draw() {
  frameRate(renderSpeed);
  overlayNorm();
  //overlayBW();
  //beginRecord(PDF, "gdtest-####.pdf");
}

void overlay() {
  for (int i = 0; i < total; i++) {
    for (int j = 0; j < total; j++) {
      x[i]=int(random(width));
      y[i]=int(random(height));
      color c = s.get(int(x[i]), int(y[i]));
      color cc = s.get(int(x[j]), int(y[j]));
      float redc = green(c);
      float redcc = green(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);

      //target the darkest pixels, but not the black background
      if (redcc >= redc && b > 0 && b < 60 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(1);
        stroke(20);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(3);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }

      //target the exact midtones
      if (redcc >= redc && b > 60 && b < 180 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(1);
        stroke(120);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(3);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }

      //target the brightest pixels, but not a white background
      if (redcc >= redc && b > 200 && b < 255 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(1);
        stroke(255);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(3);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }
    }
  }
}

//regular function, samples colors from picture
void overlayNorm() {
  for (int i = 0; i < total; i++) {
    for (int j = 0; j < total; j++) {
      x[i]=int(random(width));
      y[i]=int(random(height));
      color c = s.get(int(x[i]), int(y[i]));
      color cc = s.get(int(x[j]), int(y[j]));
      float redc = green(c);
      float redcc = green(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);
      if (redcc >= redc && b < 255 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(lineSw);
        stroke(b);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(pointSw);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }
    }
  }
}

//black on white
void overlayBW() {
  for (int i = 0; i < total; i++) {
    for (int j = 0; j < total; j++) {
      x[i]=int(random(width));
      y[i]=int(random(height));
      color c = s.get(int(x[i]), int(y[i]));
      color cc = s.get(int(x[j]), int(y[j]));
      float redc = green(c);
      float redcc = green(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);
      if (b <= 5 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(lineSw);
        stroke(c, 50);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(pointSw);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }
    }
  }
}

//target the brightest pixels separately so they stand out more
void highlights() {
  for (int i = 0; i < total; i++) {
    for (int j = 0; j < total; j++) {
      x[i]=int(random(width));
      y[i]=int(random(height));
      color c = s.get(int(x[i]), int(y[i]));
      color cc = s.get(int(x[j]), int(y[j]));
      float redc = green(c);
      float redcc = green(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);
      if (redcc >= redc && b > 235 && b < 255 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(.5);
        stroke(255);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(2);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }
    }
  }
}

void points() {
  for (int i = 0; i < total; i++) {
    x[i]=int(random(width));
    y[i]=int(random(height));
    color c = s.get(int(x[i]), int(y[i]));
    float b = brightness(c);
    if (b > 120) {
      strokeWeight(2);
      stroke(c);
      point(x[i], y[i]);
    }
  }
}

void points2() {
  for (int i = 0; i < total; i++) {
    x[i]=int(random(width));
    y[i]=int(random(height));
    color c = s.get(int(x[i]), int(y[i]));
    float b = brightness(c);
    if (b > 40 && b < 120) {
      strokeWeight(random(1, 4));
      stroke(c);
      point(x[i], y[i]);
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }

  if (key=='b'||key=='B')
  {
    beginRecord(PDF, "gdtest-####.pdf");
  }
  //End Record
  if (key=='e'||key=='E')
  {
    endRecord();
    exit();
  }
}

