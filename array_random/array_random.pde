/**
 * explore different combinations of drawing methods 
 *
 * KEYS
 * s                   : save timestamped png
 * p                   : save single-frame pdf
 * b/e                 : begin/end recording multiple-frame pdf
 * backspace           : clear background
 */

import processing.pdf.*;
import controlP5.*;
import java.util.Calendar;

PImage s;
ControlP5 cp5;
int total = 6000;
int [] x = new int[total];
int [] y = new int[total];
float smallLimit = 12;
float smallLowLimit = 4;
float lineSw = .5;
float pointSw = 1;
boolean record = false;
boolean clear = false;

//coloring options
boolean falseColor = false;
float saturationValue = 80;
float brightnessValue = 0;
color falseSwatch = color(HSB, 360, 100, 100);


void setup() {
  size(884, 1024);
  s = loadImage("n2.jpg");
  //background(0);
  setupGUI();
}

void draw() {
  if (record) beginRecord(PDF, timestamp() + ".pdf");
  overlay();
  //highlights();
  //points();
  //points2();
  if (clear) {
    fill(0);
    noStroke();
    rect(0, 0, width, height);
    clear = false;
  }
  if (record) {
    println("pdf saved");
    endRecord();
    exit();
  }
  drawGUI();
}

void overlay() {
  for (int i = 0; i < total; i++) {
    for (int j = 0; j < total; j++) {
      x[i]=int(random(width));
      y[i]=int(random(height));
      color c = s.get(int(x[i]), int(y[i]));
      color cc = s.get(int(x[j]), int(y[j]));
      float redc = blue(c);
      float redcc = blue(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);
      float opacityMap = map(distance, 0, smallLimit, 0, 255);

      //target the darkest pixels, but not the black background
      /*if (redcc > redc && b > 0 && b < 60 && distance > smallLowLimit && distance < smallLimit) {
       strokeWeight(1);
       if (falseColor) {
       stroke(falseSwatch, opacityMap);
       } else {
       stroke(c);
       }
       line(x[i], y[i], x[j], y[j]);
       strokeWeight(3);
       point(x[i], y[i]);
       point(x[j], y[j]);
       }*/

      //target the exact midtones, thinner lines
      if (redcc > redc && b > 180 && b < 220 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(.5);
        if (falseColor) {
          colorMode(HSB);
          stroke(h, saturationValue, b, opacityMap);
        } else {
          stroke(c);
        }
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(2);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }

      //target the brightest pixels, but not a white background
      if (redcc > redc && b > 220 && b < 255 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(1);
        if (falseColor) {
          stroke(falseSwatch, opacityMap);
        } else {
          stroke(c);
        }
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
      float redc = blue(c);
      float redcc = blue(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);
      float opacityMap = map(distance, 0, smallLimit, 0, 255);
      pointSw = random(.5, 2);
      if (redcc < redc && b < 240 && b > 20 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(lineSw);
        if (falseColor) {
          stroke(falseSwatch, opacityMap);
        } else {
          stroke(c);
        }
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
      float redc = blue(c);
      float redcc = blue(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);
      float opacityMap = map(distance, 0, smallLimit, 0, 255);
      if (redcc >= redc && b > 200 && b < 255 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(.5);
        if (falseColor) {
          stroke(falseSwatch, opacityMap);
        } else {
          stroke(c);
        }
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(pointSw);
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
      strokeWeight(3);
      if (falseColor) {
        stroke(falseSwatch);
      } else {
        stroke(c);
      }
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
    if (b > 175 && b < 220) {
      strokeWeight(random(1, 5));
      if (falseColor) {
        stroke(falseSwatch);
      } else {
        stroke(c);
      }
      point(x[i], y[i]);
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame(timestamp() + ".png");
    println("frame saved");
  }
  if (key=='b'||key=='B')
  {
    beginRecord(PDF, timestamp() + ".pdf");
    println("recording...");
  }
  //End Record
  if (key=='e'||key=='E')
  {
    println("pdf saved");
    endRecord();
    exit();
  }
  if (key == 'p' || key == 'P') {
    record = true;
  }
  if (key == BACKSPACE) {
    clear = true;
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}

