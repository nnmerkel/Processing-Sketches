import processing.pdf.*;
import controlP5.*;

ControlP5 cp5;
PImage first;
PImage second;

boolean switchStyle = false;
float btotal = 0;
float ctotal = 0;
//block size
int xincrement = 20;
int yincrement = 20;
float threshold = 120;

void setup() {
  size(1920, 1200);
  first = loadImage("face2.jpg");
  second = loadImage("apple.jpg");
  cp5 = new ControlP5(this);
  Group g2 = cp5.addGroup("g2").setPosition(10, 20).setWidth(200).setBackgroundColor(color(0, 80)).setBackgroundHeight(106).setLabel("Menu");
  cp5.addSlider("threshold").setPosition(4, 4).setSize(192, 20).setRange(0, 255).setGroup(g2);
  //make sure xincrement and yincrement are never set to 0 (a box cannot have 0 width) 
  cp5.addSlider("xincrement").setPosition(4, 28).setSize(192, 20).setRange(1, 200).setGroup(g2);
  cp5.addSlider("yincrement").setPosition(4, 52).setSize(192, 20).setRange(1, 200).setGroup(g2);
  cp5.addToggle("switchStyle").setPosition(4, 76).setSize(16, 16).setCaptionLabel("greater than").setGroup(g2);
}

void draw() {
  noStroke();
  //comment/uncomment to see/hide the picture
  image(first, 0, 0);
  //fill(205);
  //rect(0, 0, width, height);
  float resolution = xincrement*yincrement;
  for (int x = 0; x < width; x += xincrement) {
    for (int y = 0; y < height; y += yincrement) {
      tile(x, y, xincrement, yincrement);
      tile2(x, y, xincrement, yincrement);
      btotal = btotal / resolution;
      ctotal = ctotal / resolution;
      if (switchStyle==false) totalLessThan(x, y);
      else totalGreaterThan(x, y);
    }
  }
}

//sample the first image
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

//sample the second image
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

//these two functions should actully tile the images onto one another, but i find them
//bulky because they generate a new PImage class for each box. maybe thats fine? not sure
void firstImageTile(int startX, int startY) {
  PImage newFirst = first.get(startX, startY, xincrement, yincrement); 
  image(newFirst, startX, startY);
}

void secondImageTile(int startX, int startY) {
  PImage newSecond = second.get(startX, startY, xincrement, yincrement); 
  image(newSecond, startX, startY);
}

//the boolean flips which side of "threshold" the boxes are displayed on
void totalLessThan(int startX, int startY) {
  if (btotal < threshold) {
    stroke(255, 0, 0, 40);
    noFill();
    //firstImageTile(startX, startY);
    rect(startX, startY, xincrement, yincrement);
  }
}

//the boolean flips which side of "threshold" the boxes are displayed on
void totalGreaterThan(int startX, int startY) {
  if (btotal > threshold) {
    stroke(255, 0, 0, 40);
    noFill();
    //firstImageTile(startX, startY);
    rect(startX, startY, xincrement, yincrement);
  }
}

//trying to get the sketch to output a pdf of the onscreen result, even if its
//just the red grid lines
void saveGrid() {
  beginRecord(PDF, "grid_####.pdf");
  //fill(255);
  //stroke(255, 0, 0, 60);
  //rect(0, 0, width, height);
  noFill();
  stroke(255, 0, 0, 60);
  for (int x = 0; x < width; x += xincrement) {
    for (int y = 0; y < height; y += yincrement) {
      if (switchStyle==false) totalLessThan(x, y);
      else totalGreaterThan(x, y);
    }
  }
  endRecord();
  println("pdf saved");
  exit();
}

void keyReleased() {
  if (key == 's' || key == 'S') {
    saveFrame("frame_####.png");
    println("frame saved");
  }
  if (key == 'p' || key == 'P') {
    saveGrid();
  }
}
