int total = 100;
int [] x;
int [] y;


void setup() {
  size(800, 800);
  smooth(8);
  x = new int[total];
  y = new int[total];
}


void draw() {
  noStroke();
  fill(205);
  rect(0, 0, width, height);
  noFill();
  for ( int i = 0; i < total; i++) {
    x[i] = int(random(width));
    y[i] = int(random(height));
    stroke(0);
    strokeWeight(int(random(10)));
    point(x[i], y[i]);
  }
}

