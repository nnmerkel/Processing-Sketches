PImage s;
int total = 1000;
Point [] p;
float [] points = new float[total];

void setup() {
  size(1000, 1000);
  //s = loadImage("sphere.png");
  s = loadImage("img.jpg");
  s.loadPixels();
  //image(s, 0, 0);
  p = new Point[total];
  for (int i = 0; i < total; i++) {
    p[i] = new Point();
  }
}

void draw() {
  background(255);
  //increments control spacing values
  float xincrement = 4;
  float yincrement = 4;
  for (int x = 0; x < total; x += xincrement) {
    for (int y = 0; y < total; y += yincrement) {
      pushMatrix();
      translate(x, y);
      //get color of each pixel
      //color c = s.pixels[y*width+x];
      int imgX = (int) map(x, 0, width, 0, s.width);
      int imgY = (int) map(y, 0, height, 0, s.height);
      color c = s.pixels[imgY*s.width+imgX];
      stroke(c);
      //run a point
      p[x].display();
      popMatrix();
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

