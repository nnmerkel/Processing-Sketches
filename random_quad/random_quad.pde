float a;
float b;
float c;
float d;
float e;
float f;
float g;
float h;


void setup() {
  size(800, 800);
  smooth(8);
}



void draw() {
  background(c, e, a);
  quad(a, b, c, d, g, h, e, f);
  a= random(0, 400);
  b= random(0, 400);
  c= random(400, 800);
  d= random(0, 400);
  e= random(0, 400);
  f= random(400, 800);
  g= random(400, 800);
  h=random(400, 800);
  fill(a, c, e);
  frameRate(3);
}

