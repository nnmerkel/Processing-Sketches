import processing.pdf.*;

PurpleArc [] x;
OrangeArc [] t;
HairlineArc [] h;
OrangeHairlineArc [] y;
CircleString [] c;

int xtotal = 80; //number of purple arcs in the sketch
int ttotal = 25; //number of orange arcs in the sketch
int htotal = 170; //number of purple hairline  arcs in the sketch
int ytotal = 80; //number of orange hairline  arcs in the sketch
int ctotal = 0;

color p = color(58, 132, 182, 180);
color o = color(58, 132, 182, 180);
// color of the thick strokes
//color o = color(93, 173, 103, 200);
//background color
color f = color(255);

void setup() {
  size(700, 700, PDF, "compcoretest7.pdf");
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
  println("finished");
  exit();
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

