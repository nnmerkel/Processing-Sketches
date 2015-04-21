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
import java.util.Calendar;

// ------ ControlP5 ------

import controlP5.*;
ControlP5 cp5;
Slider[] sliders;
Range[] ranges;
Toggle[] toggles;
int guiOffset = 300;

PImage s;
int total = 6000;
int [] x = new int[total];
int [] y = new int[total];
float smallLimit = 12;
float smallLowLimit = 4;
boolean record = false;
boolean clear = false;

//drawing methods
//shadows
boolean shadowFalseColor = false;
boolean useShadows = false;
float shadowSaturation = 80;
float shadowBrightness = 80;
float shadowHue = 40;
float lowShadows = 10;
float highShadows = 60;
float shadowLineSw = .5;
float shadowPointSw = 1;

//midtones
boolean useMidtones = true;
boolean midtonesFalseColor = false;
float midtonesSaturation = 80;
float midtonesBrightness = 80;
float midtonesHue = 40;
float lowMidtones = 100;
float highMidtones = 150;
float midtonesLineSw = .5;
float midtonesPointSw = 1;

//highlights
boolean useHighlights = false;
boolean highlightsFalseColor = false;
float highlightsSaturation = 80;
float highlightsBrightness = 80;
float highlightsHue = 40;
float lowHighlights = 220;
float highHighlights = 255;
float highlightsLineSw = .5;
float highlightsPointSw = 1;


void setup() {
  size(884+guiOffset, 1024);
  s = loadImage("n2.jpg");
  background(0);
  fill(60);
  rect(0, 0, guiOffset, height);
  setupGUI();
}

void draw() {
  pushMatrix();
  translate(guiOffset, 0);
  noFill();
  colorMode(RGB, 255, 255, 255, 255);
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
  popMatrix();
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

      if (useShadows) {
        //target the darkest pixels, but not the black background
        if (redcc > redc && b > lowShadows && b < highShadows && distance > smallLowLimit && distance < smallLimit) {
          strokeWeight(shadowLineSw);
          if (shadowFalseColor) {
            colorMode(HSB, 360, 100, 100, 255);
            stroke(shadowHue, shadowSaturation, shadowBrightness, opacityMap);
          } else {
            stroke(c);
          }
          line(x[i], y[i], x[j], y[j]);
          strokeWeight(shadowPointSw);
          point(x[i], y[i]);
          point(x[j], y[j]);
        }
      }

      if (useMidtones) {
        //target the exact midtones, thinner lines
        if (redcc > redc && b > lowMidtones && b < highMidtones && distance > smallLowLimit && distance < smallLimit) {
          strokeWeight(midtonesLineSw);
          if (midtonesFalseColor) {
            colorMode(HSB, 360, 100, 100, 255);
            stroke(midtonesHue, midtonesSaturation, midtonesBrightness, opacityMap);
          } else {
            stroke(c);
          }
          line(x[i], y[i], x[j], y[j]);
          strokeWeight(midtonesPointSw);
          point(x[i], y[i]);
          point(x[j], y[j]);
        }
      }

      if (useHighlights) {
        //target the brightest pixels, but not a white background
        if (redcc > redc && b > lowHighlights && b < highHighlights && distance > smallLowLimit && distance < smallLimit) {
          strokeWeight(highlightsLineSw);
          if (highlightsFalseColor) {
            colorMode(HSB, 360, 100, 100, 255);
            stroke(highlightsHue, highlightsSaturation, highlightsBrightness, opacityMap);
          } else {
            stroke(c);
          }
          line(x[i], y[i], x[j], y[j]);
          strokeWeight(highlightsPointSw);
          point(x[i], y[i]);
          point(x[j], y[j]);
        }
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
      /*pointSw = random(.5, 2);
      if (redcc < redc && b < 240 && b > 20 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(lineSw);
        if (falseColor) {
          colorMode(HSB, 360, 100, 100, 255);
          stroke(h, saturationValue, brightnessValue, opacityMap);
        } else {
          stroke(c);
        }
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(pointSw);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }*/
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
      /*if (redcc >= redc && b > 200 && b < 255 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(lineSw);
        if (falseColor) {
          colorMode(HSB, 360, 100, 100, 255);
          stroke(h, saturationValue, brightnessValue, opacityMap);
        } else {
          stroke(c);
        }
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(pointSw);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }*/
    }
  }
}

void points() {
  for (int i = 0; i < total; i++) {
    x[i]=int(random(width));
    y[i]=int(random(height));
    color c = s.get(int(x[i]), int(y[i]));
    float b = brightness(c);
    /*if (b > 120) {
      strokeWeight(pointSw);
      if (falseColor) {
        colorMode(HSB, 360, 100, 100, 255);
        stroke(h, saturationValue, brightnessValue);
      } else {
        stroke(c);
      }
      point(x[i], y[i]);
    }*/
  }
}

void points2() {
  for (int i = 0; i < total; i++) {
    x[i]=int(random(width));
    y[i]=int(random(height));
    color c = s.get(int(x[i]), int(y[i]));
    float b = brightness(c);
    /*if (b > 175 && b < 220) {
      strokeWeight(random(1, 5));
      if (falseColor) {
        colorMode(HSB, 360, 100, 100, 255);
        stroke(h, saturationValue, brightnessValue);
      } else {
        stroke(c);
      }
      point(x[i], y[i]);
    }*/
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

