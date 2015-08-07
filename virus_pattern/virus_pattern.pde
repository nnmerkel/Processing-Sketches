/**
 KEYS
 
 s = save .tif file
 b = begin recording a pdf
 e = end recording pdf
 */

import processing.pdf.*;

float divisor = 8;
float smallDiam = 8; //normally 6

void setup() {
  /**============================================
   CHANGE SIZE PROPERTY TO YOUR PREFERRED CANVAS SIZE (IN PIXELS)
   NUMBERS ONLY, DO NOT APPEND UNITS
   =============================================*/
  size(displayWidth, displayHeight);
  smooth(8);

  /**============================================
   CHANGE BACKGROUND PROPERTY TO YOUR PREFERRED COLOR
   R, G, B, OPACITY
   =============================================*/
  background(255);
}

void draw() {
  /**============================================
   CHANGE FRAMERATE PROPERTY TO YOUR PREFERRED FRAME SPEED PER SECOND
   COMMENT IT OUT IF YOU WANT DEFAULT FRAMERATE (30)
   NUMBERS ONLY, DO NOT APPEND UNITS
   =============================================*/
  frameRate(2);

  noStroke();

  /**============================================
   1 AND 2 ARE USED TO LAY TRANSPARENT BACKGROUND OVER TOP OF CURVES (MAKES THEM LOOK FADED)
   COMMENT THEM OUT IF YOU DO NOT WANT THIS FEATURE
   1. SETS FILL COLOR (R, G, B, OPACITY)
   2. SETS RECTANGLE SIZE
   =============================================*/
  /*1*/  fill(255, 50);
  /*2*/  rect(0, 0, width, height);

  noiseCurve();
  noiseCurve();
  curve();
}

//draw a curved line end to end
void curve() {
  float randa = random(0, width);
  float randb = random(0, width);
  float diam = randb-randa;
  noFill();

  /**============================================
   CHANGE STROKE PROPERTY TO YOUR PREFERRED COLOR
   AND STROKEWEIGHT TO PREFERRED WEIGHT
   (R, G, B, OPACITY)
   =============================================*/
  stroke(29, 99, 175, 150);
  strokeWeight(1);

  bezier(randa, 0, randa, height/3, randb, height/1.5, randb, height);

  //draw solid circles at the endpoints
  noStroke();

  /**============================================
   CHANGE FILL PROPERTY TO YOUR PREFERRED COLOR FOR THE LITTLE CIRCLES
   R, G, B, OPACITY
   =============================================*/
  fill(29, 99, 175, 70);

  ellipse(randa, 0, smallDiam, smallDiam);
  ellipse(randb, height, smallDiam, smallDiam);

  //draw transparent circles, diameter based on length of curve
  /**============================================
   CHANGE FILL PROPERTY TO YOUR PREFERRED COLOR FOR THE BIGGER CIRCLES
   R, G, B, OPACITY
   =============================================*/
  fill(29, 99, 175, 70);

  ellipse(randa, 0, diam/divisor, diam/divisor);
  ellipse(randb, height, diam/divisor, diam/divisor);
}

//curve using noise rather than random
float xoff = 0.0;
float x2off = 0.0;

void noiseCurve() {
  float randa = noise(xoff) * width;
  float randb = noise(x2off) * width;
  float diam = randb-randa;
  xoff = xoff + .1;
  x2off = x2off + .25;
  noFill();

  /**============================================
   CHANGE STROKE PROPERTY TO YOUR PREFERRED COLOR
   AND STROKEWEIGHT TO PREFERRED WEIGHT
   (R, G, B, OPACITY)
   =============================================*/
  stroke(29, 99, 175, 150);
  strokeWeight(1);

  bezier(randa, 0, randa, height/3, randb, height/1.5, randb, height);
  fill(29, 99, 175, 150);
  ellipse(randa, height/3, smallDiam, smallDiam);
  ellipse(randb, height/1.5, smallDiam, smallDiam);

  //draw solid circles at the endpoints
  noStroke();

  /**============================================
   CHANGE FILL PROPERTY TO YOUR PREFERRED COLOR FOR THE LITTLE CIRCLES
   R, G, B, OPACITY
   =============================================*/
  fill(29, 99, 175, 70);

  ellipse(randa, 0, smallDiam, smallDiam);
  ellipse(randb, height, smallDiam, smallDiam);

  //draw transparent circles, diameter based on length of curve
  /**============================================
   CHANGE FILL PROPERTY TO YOUR PREFERRED COLOR FOR THE BIGGER CIRCLES
   R, G, B, OPACITY
   =============================================*/
  fill(29, 99, 175, 70);

  ellipse(randa, 0, diam/divisor, diam/divisor);
  ellipse(randb, height, diam/divisor, diam/divisor);
}

void keyPressed() {
  if (key=='s' || key=='S') {
    saveFrame();
    println("frame saved");
  }
  if (key == 'b'|| key == 'B') {
    beginRecord(PDF, "virusexp_####.pdf");
    println("recording...");
  }
  if (key == 'e'|| key == 'E') {
    endRecord();
    println("pdf saved. press command + k to view");
    exit();
  }
}

