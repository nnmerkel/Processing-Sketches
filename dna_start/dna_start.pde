Strand [] s;
int total = 20;
float randNum = random(0, 10);
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
  //create one middle strand section
  //it goes to +x
  for (int i = 0; i < total; i += r+gap) {
    s[i].partOne();
  }
}

