import controlP5.*;

ControlP5 cp5;
PImage first;
PImage second;

float btotal = 0;
float ctotal = 0;
//block size
int xincrement = 27;
int yincrement = 27;
float threshold = 120;

void setup() {
  size(1920, 1200);
  first = loadImage("face2.jpg");
  second = loadImage("apple.jpg");
  cp5 = new ControlP5(this);
  //background(first);
  //GUI styles
  //fill(50);
  //rect(0, 0, 208, height);
  cp5.addSlider("threshold").setPosition(4, 4).setSize(200, 30).setRange(0, 255);
  //make sure xincrement and yincrement are never set to 0 (a box cannot have 0 width) 
  cp5.addSlider("xincrement").setPosition(4, 38).setSize(200, 30).setRange(1, 200);
  cp5.addSlider("yincrement").setPosition(4, 72).setSize(200, 30).setRange(1, 200);
}

void draw() {
  noStroke();
  image(first, 0, 0);
  float resolution = xincrement*yincrement;
  for (int x = 0; x < width; x+=xincrement) {
    for (int y = 0; y < height; y+=yincrement) {
      tile(x, y, xincrement, yincrement);
      tile2(x, y, xincrement, yincrement);
      btotal = btotal / resolution;
      ctotal = ctotal / resolution;
      if (btotal < threshold) {
        stroke(255, 0, 0);
        noFill();
        rect(x, y, xincrement, yincrement);
        //firstImageTile(x, y);
      } else {
        //secondImageTile(x, y);
      }
    }
  }
  //noLoop();
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

void tile2(int startx, int starty, int tileSizeX, int tileSizeY) {
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

void firstImageTile(int startX, int startY) {
  PImage newFirst = first.get(startX, startY, xincrement, yincrement); 
  image(newFirst, startX, startY);
}

void secondImageTile(int startX, int startY) {
  PImage newSecond = second.get(startX, startY, xincrement, yincrement); 
  image(newSecond, startX, startY);
}

void keyReleased() {
  if (key == 's' || key == 'S') {
    saveFrame("frame_####.png");
    println("frame saved");
  }
}

