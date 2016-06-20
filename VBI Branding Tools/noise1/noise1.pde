/**
 KEYS
 
 s = save .tif file
 p = save pdf
 */

import processing.pdf.*;
import java.util.Calendar;

float yoff = 0.15;

/**============================================
 CHANGE FUNCTIONCOUNT TO THE NUMBER OF LINES YOU WANT IN THE RESULT
 NUMBER ONLY, DO NOT APPEND UNITS
 =============================================*/
int functionCount = 255;

boolean record;

void setup() {
  /**============================================
   CHANGE SIZE PROPERTY TO YOUR PREFERRED CANVAS SIZE (IN PIXELS)
   NUMBERS ONLY, DO NOT APPEND UNITS
   =============================================*/
  size(1280, 720);
}

void draw() {
  if (record) beginRecord(PDF, timestamp() + ".pdf");

  /**============================================
   CHANGE BACKGROUND PROPERTY TO YOUR PREFERRED COLOR
   R, G, B, OPACITY
   =============================================*/
  background(255);
  //looks bad with fill
  noFill();
  for (int i = 0; i < functionCount; i++) {
    float opacity = map(i, 0, 255, 50, functionCount);
    /**============================================
     CHANGE STROKE PROPERTY TO YOUR PREFERRED COLOR
     DO NOT CHANGE THE OPACITY VARIABLE, ONLY CHANGE THE RGB VALUES
     (R, G, B, OPACITY)
     =============================================*/
    stroke(0, opacity);
    snufflupagus();
  }
  if (record) {
    endRecord();
    println("pdf saved");
  }
}

//create waves
void snufflupagus() {
  beginShape(); 
  float xoff = yoff;
  // do stuff
  for (float x = 0; x <= width; x += 30) {
    // Calculate a y value according to noise, map to 
    float y = map(noise(xoff, yoff), 0, 1, 1100, height-1000);
    vertex(x, y);

    /**============================================
     THIS SETS HOW "SPIKY" EACH LINE APPEARS
     .25 = PRETTY SPIKY, .1-.05 FOR WATER-LIKE SURFACE
     =============================================*/
    //this sets how "spiky" each ribbon appears; .25 for desktopBG, .1-.15 for water
    xoff += 0.035;
  }
  /**============================================
   THIS SETS HOW FAR APART ANCHORS ARE PLACED
   YOU PROBABLY DO NOT NEED TO CHANGE IT BUT YOU ARE FREE TO EXPERIMENT
   =============================================*/
  yoff += 0.03;
  endShape();
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

//save frame function
void keyPressed() {
  if (key=='s') {
    saveFrame();
    println("frame saved");
  }
  if (key == 'B' || key == 'B') {
    record = true;
  }
}