Ball [] b;
int total = 50;


void setup() {
  size(300, 300);
  smooth(8);
  b = new Ball[total];
  for (int i = 0; i < total; i++) {
    b[i] = new Ball();
  }
}



void draw() {
//  fill(205, 70);
//  noStroke();
//  rect(0, 0, width, height);
  for(int i = 0; i < total; i++) {
    b[i].run();
  }
}

