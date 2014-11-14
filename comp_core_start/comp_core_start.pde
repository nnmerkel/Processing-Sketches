import processing.pdf.*;

PurpleArc [] x;
OrangeArc [] t;
HairlineArc [] h;
OrangeHairlineArc [] y;
CircleString [] c;

int xtotal = 200; //number of purple arcs in the sketch
int ttotal = 60; //number of orange arcs in the sketch
int htotal = 250; //number of purple hairline  arcs in the sketch
int ytotal = 200; //number of orange hairline  arcs in the sketch
int ctotal = 0;

// 179, 49, 136, 190 purple
// 234, 137, 38, 220 orange
// 67, 164, 227, 180 blue
// 201, 82, 155, 190 magenta
color p = color(255, 75);
// color of the thick strokes
color o = color(255, 180);
//background color
color f = color(0, 40);

void setup() {
  size(displayWidth, displayHeight);//, PDF, "compcoretest2.pdf");
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
  fill(f);
  noStroke();
  rect(0, 0, width, height);
  //draw the arcs individually
  //keep i incremented as i++ so that total 
  //controls the number of arcs rendered
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
  //println("finished");
  //exit();
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

