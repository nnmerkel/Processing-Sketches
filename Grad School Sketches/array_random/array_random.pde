/**
 * explore different combinations of drawing methods 
 *
 * KEYS
 * s                   : save timestamped png
 * b/e                 : begin/end recording multiple-frame pdf
 * backspace           : clear background
 *
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

//drawing modes
boolean orthogonal = false;
boolean random = true;

int total = 2000;
int [] x = new int[total];
int [] y = new int[total];

float smallLimit = 40;
float highlightsLowLimit, midLowLimit, shadowLowLimit;
boolean clear = false;
boolean recording = false;

color background = color(255);

//drawing methods
//shadows
boolean shadowFalseColor = false;
boolean useShadows = false;
float shadowSaturation = 80;
float shadowBrightness = 80;
float shadowHue = 40;
float lowShadows = 0;
float highShadows = 50;
float shadowLineSw = .5;
float shadowPointSw = 2;

//midtones
//same variables as for shadows, but this time target the midtones
boolean useMidtones = true;
boolean midtonesFalseColor = false;
float midtonesSaturation = 80;
float midtonesBrightness = 80;
float midtonesHue = 40;
float lowMidtones = 140;
float highMidtones = 170;
float midtonesLineSw = 1;
float midtonesPointSw = 2;

//highlights
//same variables as shadows and midtones, but this time target the highlights
boolean useHighlights = false;
boolean highlightsFalseColor = false;
float highlightsSaturation = 80;
float highlightsBrightness = 80;
float highlightsHue = 40;
float lowHighlights = 238;
float highHighlights = 255;
float highlightsLineSw = .5;
float highlightsPointSw = 1.5;


void setup() {
  size(1280, 800);
  pixelDensity(2);

  s = loadImage("n.jpg");

  colorMode(RGB, 255, 255, 255, 255);
  background(background);
  noFill();
  noStroke();

  //GUI
  fill(160);
  rect(0, 0, guiOffset, height);
  //image(s, guiOffset, 0);
  setupGUI();
}


void draw() {
  pushMatrix();
  translate(guiOffset, 0);

  if (random) {
    overlay();
  } else {
    orthongonalOverlay(15, 15);
  }

  if (clear) {
    fill(background);
    noStroke();
    rect(0, 0, width, height);
    clear = false;
  }

  popMatrix();
}


void overlay() {
  for (int i = 0; i < total; i++) {
    for (int j = 0; j < total; j++) {
      x[i] = int(random(width));
      y[i] = int(random(height));

      color c = s.get(int(x[i]), int(y[i]));
      color cc = s.get(int(x[j]), int(y[j]));
      float redc = red(c);
      float redcc = red(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);
      float opacityMap = map(distance, 0, smallLimit, 0, 255);

      if (useShadows) {
        //target the darkest pixels, but not the black background
        if (redcc <= redc && b >= lowShadows && b < highShadows && distance > shadowLowLimit && distance < smallLimit) {
          strokeWeight(shadowLineSw);
          if (shadowFalseColor) {
            colorMode(HSB, 360, 100, 100, 255);
            stroke(shadowHue, shadowSaturation, shadowBrightness, opacityMap);
          } else {
            stroke(c);
            line(x[i], y[i], x[j], y[j]);
            strokeWeight(shadowPointSw);
            point(x[i], y[i]);
            stroke(cc);
            point(x[j], y[j]);
          }
        }
      }

      if (useMidtones) {
        //target the exact midtones, thinner lines
        if (redcc < redc && b > lowMidtones && b < highMidtones && distance > midLowLimit && distance < smallLimit) {
          strokeWeight(midtonesLineSw);
          if (midtonesFalseColor) {
            colorMode(HSB, 360, 100, 100, 255);
            stroke(midtonesHue, midtonesSaturation, midtonesBrightness, opacityMap);
          } else {
            stroke(c, opacityMap);
            line(x[i], y[i], x[j], y[j]);
            strokeWeight(midtonesPointSw);
            point(x[i], y[i]);
            stroke(cc);
            point(x[j], y[j]);
          }
        }
      }

      if (useHighlights) {
        //target the brightest pixels, but not a white background
        if (redcc <= redc && b > lowHighlights && b < highHighlights && distance > highlightsLowLimit && distance < smallLimit) {
          strokeWeight(highlightsLineSw);
          if (highlightsFalseColor) {
            colorMode(HSB, 360, 100, 100, 255);
            stroke(highlightsHue, highlightsSaturation, highlightsBrightness, opacityMap);
          } else {
            stroke(c, opacityMap);
            line(x[i], y[i], x[j], y[j]);
            strokeWeight(highlightsPointSw);
            point(x[i], y[i]);
            stroke(cc);
            point(x[j], y[j]);
          }
        }
      }
    }
  }
}


//90 degree version of overlay
void orthongonalOverlay(int xStep, int yStep) {
  for (int i = 0; i < total; i+=xStep) {
    for (int j = 0; j < total; j+=yStep) {
      color c = s.get(x[i], y[i]);
      float redc = red(c);
      //float redcc = red(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);
      float opacityMap = map(distance, 0, smallLimit, 0, 255);

      x[i] = j;
      y[i] = i;
    }
  }
}


//test to see how close the points can be before they are too close
void proximityTest() {
  if (useHighlights) {
    highlightsLowLimit = highlightsPointSw * 2;
  }

  if (useMidtones) {
    midLowLimit = midtonesPointSw * 2;
  }

  if (useShadows) {
    shadowLowLimit = shadowPointSw * 2;
  }
}


void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame(timestamp() + ".png");
    println("frame saved");
  }

  if (key=='b' || key=='B')
  {
    recording = true;
    beginRecord(PDF, timestamp() + ".pdf");
    println("recording...");
  }

  if (key=='e' || key=='E')
  {
    println("pdf saved");
    endRecord();
    recording = false;
    exit();
  }

  if (key == BACKSPACE) {
    clear = true;
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}