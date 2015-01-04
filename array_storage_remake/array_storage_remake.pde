//libraries
import processing.pdf.*;
import controlP5.*;

//classes
PImage s;
ControlP5 cp5;

//array variables
int total = 10000;
int [] x = new int[total];
int [] y = new int[total];

//regular variables
float bigLimit = 0;
float smallLimit = 0;
float smallLowLimit = 2;
float bigLowLimit = 50;
float lineSw = .5;
float pointSw = 2;
int renderSpeed = 4;

//GUI elements
int guiWidth = 212;

void setup() {
  size(2132, 1200);
  s = loadImage("face2.jpg");
  background(255);
  fill(50);
  rect(0, 0, guiWidth, height);
  cp5 = new ControlP5(this);
  //cp5.addSlider("total").setPosition(0, 0).setSize(200, 20).setRange(100, 10000).setValue(100);
  cp5.addSlider("smallLimit").setPosition(6, 22).setSize(200, 20).setRange(4, 500);
  cp5.addSlider("renderSpeed").setPosition(6, 44).setSize(200, 20).setRange(1, 60);
  cp5.addSlider("lineSw").setPosition(6, 66).setSize(200, 20).setRange(.5, 3.5).setNumberOfTickMarks(7);
  cp5.addSlider("pointSw").setPosition(6, 88).setSize(200, 20).setRange(.5, 3.5).setNumberOfTickMarks(7);
}

void draw() {
  frameRate(renderSpeed);
  overlayNorm();
  noLoop();
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
      if (redcc >= redc && b < 255 && distance > smallLowLimit && distance < bigLimit) {
        strokeWeight(lineSw);
        stroke(b, 50);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(pointSw);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }
    }
  }
}
