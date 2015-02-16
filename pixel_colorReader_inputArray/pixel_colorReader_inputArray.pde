import processing.pdf.*;
import controlP5.*;

ControlP5 cp5;

PImage master;
PImage[] images;
String[] imageNames;
int imageCount = 1;

boolean switchStyle = false;
float btotal = 0;
float [] bValues;
//block size
int xincrement = 100;
int yincrement = 100;
float resolution = xincrement*yincrement;
float threshold = 120;

void setup() {
  size(1920, 1200);
  //load master image to be collaged
  master = loadImage("face2.jpg");

  //control GUI
  cp5 = new ControlP5(this);
  Group g2 = cp5.addGroup("g2").setPosition(10, 20).setWidth(200).setBackgroundColor(color(0, 80)).setBackgroundHeight(106).setLabel("Menu");
  cp5.addSlider("threshold").setPosition(4, 4).setSize(192, 20).setRange(0, 255).setGroup(g2).setValue(120);
  //make sure xincrement and yincrement are never set to 0 (a box cannot have 0 width) 
  cp5.addSlider("xincrement").setPosition(4, 28).setSize(192, 20).setRange(1, 200).setGroup(g2);
  cp5.addSlider("yincrement").setPosition(4, 52).setSize(192, 20).setRange(1, 200).setGroup(g2);
  cp5.addToggle("switchStyle").setPosition(4, 76).setSize(16, 16).setCaptionLabel("greater than").setGroup(g2);
}

void draw() {
  noStroke();
  image(master, 0, 0);
  for (int x = 0; x < width; x += xincrement) {
    for (int y = 0; y < height; y += yincrement) {
      stroke(255, 0, 0, 40);
      noFill();
      rect(x, y, xincrement, yincrement);
    }
  }
}

//sample the master image
void tile(PImage theImage, int startx, int starty, int tileSizeX, int tileSizeY) {
  btotal = 0;
  int tileX = tileSizeX + startx;
  int tileY = tileSizeY + starty;
  for (int x = startx; x < tileX; x++) {
    for (int y = starty; y < tileY; y++) {
      color c1 = theImage.get(x, y);
      float b1 = brightness(c1);
      btotal = btotal + b1;
    }
  }
}

//these two functions should actully tile the images onto one another
void firstImageTile(int startX, int startY) {
  PImage newFirst = master.get(startX, startY, xincrement, yincrement); 
  image(newFirst, startX, startY);
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

void dissect() {
  //find directory of smaple images NOTE: it doesn't work well if the folder is in "data"
  File dir = new File(sketchPath, "../samples");
  if (dir.isDirectory()) {
    String[] contents = dir.list();
    images = new PImage[contents.length]; 
    imageNames = new String[contents.length]; 
    for (int i = 0; i < contents.length; i++) {
      // skip hidden files and folders starting with a dot, load .png files only
      if (contents[i].charAt(0) == '.') continue;
      else if (contents[i].equals("master.png") || contents[i].equals("master.jpg")) continue;
      else if (contents[i].toLowerCase().endsWith(".png")) {
        File childFile = new File(dir, contents[i]);        
        images[imageCount] = loadImage(childFile.getPath());
        imageNames[imageCount] = childFile.getName();
        println(imageCount+" "+contents[i]+"  "+childFile.getPath());

        int tileIndex = 0;
        //run dissection on each image in the folder
        for (int x = 0; x < images[imageCount].width; x += xincrement) {
          for (int y = 0; y < images[imageCount].height; y += yincrement) {
            btotal = 0;
            //count each tile
            tile(images[imageCount], x, y, xincrement, yincrement);
            btotal = btotal / resolution;
            //store average brightness for this tile in an array
            //println(bValues[i]);
            //bValues[tileIndex] = btotal;
            tileIndex++;
            println(tileIndex, "image # ", imageCount, " ", imageNames[imageCount], x, y, btotal);
          }
        }
        imageCount++;
      }
    }
  }
}

//trying to get the sketch to output a pdf of the onscreen result, even if its
//just the red grid lines
void saveGrid() {
  beginRecord(PDF, "grid_####.pdf");
  noFill();
  for (int x = 0; x < width; x += xincrement) {
    for (int y = 0; y < height; y += yincrement) {
      //tile(x, y, xincrement, yincrement);
      btotal = btotal / resolution;
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
  if (key == 'd' || key == 'D') {
    dissect();
  }
}

