Strand [] s;

int total = 200; 
//total and totalCircles are related somehow, namely that if totalCircles is greater than total, the sketch will
//not run due to an error with iteration total < i*(r+gap). iterations are calculated in multiples of (r+gap)
float r = 10;
float gap = 2;

void setup() {
  size(800, 800, P2D);
  smooth(8);
  s = new Strand[total];
  for (int i = 0; i < total; i++) {
    s[i] = new Strand();
  }
}

void draw() {
  background(0, 255, 0);
  for (int i = 0; i < total; i+=30) {
    pushMatrix();
    translate(width/2, height/2);
    rotate(radians(i));
    s[i].middle();
    popMatrix();
  }
  
  stroke(255, 0, 0);
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
}
