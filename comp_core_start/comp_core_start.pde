//look at me im a change
PurpleArc [] x;
OrangeArc [] t;
HairlineArc [] h;

CircleString c;
int xtotal = 60; //number of purple arcs in the sketch
int ttotal = 20; //number of orange arcs in the sketch
int htotal = 80; //number of hairline  arcs in the sketch

void setup() {
  size(800, 800, P2D);
  smooth(8);
  x = new PurpleArc[xtotal];
  t = new OrangeArc[ttotal];
  h = new HairlineArc[htotal];
  
  for (int i = 0; i < xtotal; i++) {
    x[i] = new PurpleArc();
  }
  
  for (int i = 0; i < ttotal; i++) {
    t[i] = new OrangeArc();
  }
  
  for (int i = 0; i < htotal; i++) {
    h[i] = new HairlineArc();
  }
}

void draw() {
  fill(230);
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
  //c.display();
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

