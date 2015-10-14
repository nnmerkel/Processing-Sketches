/**
 * explore different combinations of drawing methods 
 *
 * KEYS
 * s                   : save timestamped png
 * b/e                 : begin/end recording multiple-frame pdf
 * backspace           : clear background
 
 REMEMBER: you can use the GUI to check out a live preview of your options, but as of now
 there is a bug with loadFont in the pdf export library. make sure you disable the GUI by
 commenting out the appropriate lines below (they are marked). DO NOT edit the GUI tab
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

/**============================================
 Change total to any number you want. denotes the number of points
 laid down each pass. The larger the number the longer it takes to generate.
 NUMBER ONLY, DO NOT APPEND UNITS
 =============================================*/
int total = 1000;

int [] x = new int[total];
int [] y = new int[total];

/**============================================
 Change smallLimit to any number you want. denotes the maximum distance 
 between two points to be connected with a line. Smaller values create finer
 detail but larger values look more "network-y"
 NUMBER ONLY, DO NOT APPEND UNITS
 =============================================*/
float smallLimit = 40;

float smallLowLimit = 4;
boolean clear = false;

//drawing methods
//shadows
/**============================================
 Change the following variables ONLY if you are recording a pdf with
 the GUI disabled. There is no need to change these variables if you have
 it enabled as the sliders and toggles will live-update
 BOOLEAN: TRUE/FALSE ONLY
 ALL ELSE: NUMBER ONLY, DO NOT APPEND UNITS
 =============================================*/
boolean shadowFalseColor = false; //if you want to make these values appear in false color
boolean useShadows = false; //if you want to use shadows
float shadowSaturation = 80; //'s' value in HSV color
float shadowBrightness = 80; //'v' value in HSV color
float shadowHue = 40; //'h' value in HSV color
float lowShadows = 0; //lower color limit, 0=black
float highShadows = 50; //upper color limit
float shadowLineSw = .5; //line strokeweight
float shadowPointSw = 2; //dot strokeweight

//midtones
//same variables as for shadows, but this time target the midtones
boolean useMidtones = false;
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
boolean useHighlights = true;
boolean highlightsFalseColor = false;
float highlightsSaturation = 80;
float highlightsBrightness = 80;
float highlightsHue = 40;
float lowHighlights = 238;
float highHighlights = 255;
float highlightsLineSw = .5;
float highlightsPointSw = 1.5;


void setup() {
  /**============================================
   if recording a pdf, delete the "+guiOffset" statement in the size funtion,
   otherwise, change the numbers to the exact dimensions of your image
   =============================================*/
  size(1920, 1080);
  pixelDensity(2);

  /**============================================
   Change this to the exact name of your image, extension included
   =============================================*/
  s = loadImage("n2-burn.jpg");

  /**============================================
   Change this to the background color you want the result to be
   R, G, B, opacity
   =============================================*/
  background(0);

  noStroke();

  /**============================================
   Comment out the following 6 lines to disable the GUI
   =============================================*/
  fill(160);
  rect(0, 0, guiOffset, height);
  pushMatrix();
  translate(guiOffset, 0);
  popMatrix();
  setupGUI();
}

void draw() {

  /**============================================
   Comment out the following 2 lines if GUI is disabled
   =============================================*/
  pushMatrix();
  translate(guiOffset, 0);

  noFill();
  colorMode(RGB, 255, 255, 255, 255);
  overlay();
  if (clear) {
    fill(255);
    noStroke();
    rect(0, 0, width, height);
    clear = false;
  }

  /**============================================
   Comment out the following line if GUI is disabled
   =============================================*/
  popMatrix();
}

void overlay() {
  for (int i = 0; i < total; i++) {
    for (int j = 0; j < total; j++) {
      x[i]=int(random(width));
      y[i]=int(random(height));

      color c = s.get(int(x[i]), int(y[i]));
      color cc = s.get(int(x[j]), int(y[j]));
      float redc = red(c);
      float redcc = red(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);
      float opacityMap = map(distance, 0, smallLimit, 0, 255);

      if (useShadows) {
        //target the darkest pixels, but not the black background
        if (redcc >= redc && b >= lowShadows && b < highShadows && distance > smallLowLimit && distance < smallLimit) {
          strokeWeight(shadowLineSw);
          if (shadowFalseColor) {
            colorMode(HSB, 360, 100, 100, 255);
            stroke(shadowHue, shadowSaturation, shadowBrightness, opacityMap);
          } else {
            stroke(c);
          }
          noFill();
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
            stroke(c, opacityMap);
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
            stroke(c, opacityMap);
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
  if (key == BACKSPACE) {
    clear = true;
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}