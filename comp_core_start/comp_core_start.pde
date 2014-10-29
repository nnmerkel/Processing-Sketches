//look at me im a change
Arc [] x;
int total = 10; //number of arcs in the sketch

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
  for (int i = 0; i < total; i += 100) {
    x[i].run();
  }
  
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

