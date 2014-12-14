PImage sphere;
float btotal = 0;
int xincrement = 100;
int yincrement = 100;

void setup() {
  size(800, 800);
  float maxpixel = xincrement*yincrement;
  sphere = loadImage("sphere.png");
  for (int x = 0; x < xincrement; x++) {
    for (int y = 0; y < yincrement; y++) {
      color c1 = sphere.get(x, y);
      float b1 = brightness(c1);
      btotal = btotal + b1;
    }
  }
  btotal = btotal / maxpixel;
  println(btotal);
  println(maxpixel);
}

void draw() {
  image(sphere, 0, 0);
  fill(btotal);
  rect(0, 0, 100, 100);
}

