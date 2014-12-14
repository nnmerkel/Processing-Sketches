PImage first;
PImage second;
float btotal = 0;
float ctotal = 0;
//block size
int xincrement = 10;
int yincrement = 10;

void setup() {
  size(2448, 2448);
  first = loadImage("ap.jpg");
  second = loadImage("ldc.jpg");
}

void draw() {
  //image(sphere, 0, 0);
  float maxpixel = xincrement*yincrement;
  for (int x = 0; x < width; x+=xincrement) {
    for (int y = 0; y < height; y+=yincrement) {
      tile(x, y, xincrement, yincrement);
      btotal = btotal / maxpixel;
      noStroke();
      if (ctotal > 130) {
        fill(btotal);
      } else {
        fill(btotal);
      }
      //fill(ctotal);
      rect(x, y, xincrement, yincrement);
    }
  }
  
  for (int x = 0; x < width; x+=xincrement) {
    for (int y = 0; y < height; y+=yincrement) {
      tileApple(x, y, xincrement, yincrement);
      ctotal = ctotal / maxpixel;
      noStroke();
      if (ctotal > 130) {
        fill(btotal);
      } else {
        fill(btotal);
      }
      //fill(ctotal);
      rect(x, y, xincrement, yincrement);
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

void tileApple(int startx, int starty, int tileSizeX, int tileSizeY) {
  ctotal = 0;
  int tileX = tileSizeX + startx;
  int tileY = tileSizeY + starty;
  for (int x = startx; x < tileX; x++) {
    for (int y = starty; y < tileY; y++) {
      color c2 = second.get(x, y);
      float b2 = brightness(c2);
      ctotal = ctotal + b2;
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

