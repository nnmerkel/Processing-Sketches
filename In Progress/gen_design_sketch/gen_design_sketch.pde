PImage first;
PFont font;
float btotal = 0;
float ctotal = 0;
//block size
int xincrement = 10;
int yincrement = 10;

void setup() {
  size(800, 800);
  first = loadImage("sphere.png");
  font = createFont("Silom", 14);
}

void draw() {
  //image(sphere, 0, 0);
  float maxpixel = xincrement*yincrement;
  for (int x = 0; x < width; x+=xincrement) {
    for (int y = 0; y < height; y+=yincrement) {
      tile(x, y, xincrement, yincrement);
      btotal = btotal / maxpixel;
      noStroke();
      fill(btotal);
      //rect(x, y, xincrement, yincrement);
      text("0", x, y);
    }
  }
  noLoop();
}

void tile(int startx, int starty, int tileSizeX, int tileSizeY) {
  btotal = 0;
  int tileX = tileSizeX + startx;
  int tileY = tileSizeY + starty;
  for (int x = startx; x < tileX; x++) {
    for (int y = starty; y < tileY; y++) {
      color c1 = first.get(x, y);
      float b1 = brightness(c1);
      btotal = btotal + b1;
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

