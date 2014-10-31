//look at me im a change
Arc [] x;
int total = 50; //number of arcs in the sketch

void setup() {
  size(800, 800, P2D);
  smooth(8);
  x = new Arc[total];
  for (int i = 0; i < total; i++) {
    x[i] = new Arc();
  }
}

void draw() {
  fill(0, 0, 48);
  noStroke();
  rect(0, 0, width, height);
  //draw the arcs individually
  //keep i incremented as i++ so that total 
  //controls the number of arcs rendered
  for (int i = 0; i < total; i ++) {
    pushMatrix();
    translate(width/2, height/2);
    x[i].run();
    popMatrix();
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

