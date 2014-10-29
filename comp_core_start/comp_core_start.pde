//look at me im a change
Arc [] x;
int total = 2; //number of arcs in the sketch
float rot = 0;

void setup() {
  size(800, 800, P2D);
  smooth(8);
  x = new Arc[total];
  for (int i = 0; i < total; i++) {
    x[i] = new Arc();
  }
}

void draw() {
  frameRate(10);
  //draw the arcs individually
  //keep i incremented as i++ so that total 
  //controls the number of arcs rendered
  rot = rot + 1;
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(rot));
  for (int i = 0; i < total; i ++) {
    x[i].run();
  }
  popMatrix();
  noLoop();
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

