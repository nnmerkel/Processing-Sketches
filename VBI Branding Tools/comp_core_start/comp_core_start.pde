/**
 *
 * KEYS
 * s                   : save timestamped png
 * p                   : record single-frame pdf
 */

import processing.pdf.*;
import java.util.Calendar;

PurpleArc [] x;
OrangeArc [] t;
HairlineArc [] h;
OrangeHairlineArc [] y;
CircleString [] c;

/**============================================
 Change totals to any number you want. denotes the number of arcs
 of each type that will be generated
 NUMBER ONLY, DO NOT APPEND UNITS
 =============================================*/
int xtotal = 30; //number of purple arcs in the sketch
int ttotal = 60; //number of orange arcs in the sketch
int htotal = 0; //number of purple hairline  arcs in the sketch
int ytotal = 0; //number of orange hairline  arcs in the sketch
int ctotal = 0;

/**============================================
 Change p, o, and f to any colors you want. p is color number 1, o is color
 number 2, and f is the background color
 R, G, B, opacity
 =============================================*/
color p = color(58, 132, 182, 180);
color o = color(58, 132, 182, 180);
color f = color(255);

boolean record = false;

void setup() {
  size(700, 700);
  smooth(8);
  c = new CircleString[ctotal];
  x = new PurpleArc[xtotal];
  t = new OrangeArc[ttotal];
  h = new HairlineArc[htotal];
  y = new OrangeHairlineArc[ytotal];

  for (int i = 0; i < xtotal; i++) {
    x[i] = new PurpleArc();
  }

  for (int i = 0; i < ttotal; i++) {
    t[i] = new OrangeArc();
  }

  for (int i = 0; i < htotal; i++) {
    h[i] = new HairlineArc();
  }

  for (int i = 0; i < ytotal; i++) {
    y[i] = new OrangeHairlineArc();
  }

  for (int i = 0; i < ctotal; i++) {
    c[i] = new CircleString();
  }
}

void draw() {
  if (record) {
    beginRecord(PDF, timestamp() + ".pdf");
    println("recording...");
  }
  fill(f);
  noStroke();
  rect(0, 0, width, height);
  for (int i = 0; i < xtotal; i ++) {
    pushMatrix();
    translate(width/2, height/2);
    x[i].run();
    popMatrix();
  }

  //run orange arcs
  for (int i = 0; i < ttotal; i ++) {
    pushMatrix();
    translate(width/2, height/2);
    t[i].run();
    popMatrix();
  }

  //run hairline arcs
  for (int i = 0; i < htotal; i ++) {
    pushMatrix();
    translate(width/2, height/2);
    h[i].run();
    popMatrix();
  }

  //run orange hairline arcs
  for (int i = 0; i < ytotal; i ++) {
    pushMatrix();
    translate(width/2, height/2);
    y[i].run();
    popMatrix();
  }

  for (int i = 0; i < ctotal; i++) {
    pushMatrix();
    translate(width/2, height/2);
    c[i].display();
    popMatrix();
  }

  if (record) {
    endRecord();
    println("finished");
    exit();
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame(timestamp() + ".png");
    println("frame saved");
  }
  if (key == 'p' || key == 'P') {
    record = true;
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}

