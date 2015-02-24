import processing.pdf.*;
import controlP5.*;

ControlP5 cp5;

PImage master;
PImage[] images;
String[] imageNames;
int imageCount = 1;

boolean switchStyle = false;
boolean savePDF = false;
float bTotal = 0;
float mTotal = 0;
//block size
int xIncrement = 100;
int yIncrement = 100;
float resolution = xIncrement*yIncrement;
float threshold = 120;

void setup() {
  size(1920, 1200);
  //load master image to be collaged
  master = loadImage("face2.jpg");

  //control GUI
  cp5 = new ControlP5(this);
  Group g2 = cp5.addGroup("g2").setPosition(10, 20).setWidth(200).setBackgroundColor(color(0, 80)).setBackgroundHeight(106).setLabel("Menu");
  cp5.addSlider("threshold").setPosition(4, 4).setSize(192, 20).setRange(0, 255).setGroup(g2).setValue(120);
  //make sure xIncrement and yIncrement are never set to 0 (a box cannot have 0 width) 
  cp5.addSlider("xIncrement").setPosition(4, 28).setSize(192, 20).setRange(1, 200).setGroup(g2);
  cp5.addSlider("yIncrement").setPosition(4, 52).setSize(192, 20).setRange(1, 200).setGroup(g2);
  cp5.addToggle("switchStyle").setPosition(4, 76).setSize(16, 16).setCaptionLabel("greater than").setGroup(g2);
}

void draw() {
  if (savePDF == true) beginRecord(PDF, "grid_####.pdf");
  noStroke();
  image(master, 0, 0);
  for (int x = 0; x < width; x += xIncrement) {
    for (int y = 0; y < height; y += yIncrement) {
      stroke(255, 0, 0, 40);
      noFill();
      rect(x, y, xIncrement, yIncrement);
    }
  }
  if (savePDF) {
    savePDF = false;
    endRecord();
    exit();
  }
}

//sample the master image
void tile(PImage theImage, int startX, int startY, int tileSizeX, int tileSizeY) {
  bTotal = 0;
  mTotal = 0;
  int tileX = tileSizeX + startX;
  int tileY = tileSizeY + startY;
  for (int x = startX; x < tileX; x++) {
    for (int y = startY; y < tileY; y++) {
      color c1 = theImage.get(x, y);
      float b1 = brightness(c1);
      bTotal = bTotal + b1;
      mTotal = mTotal + b1;
    }
  }
}

//these two functions should actully tile the images onto one another
void firstImageTile(int startX, int startY) {
  PImage newFirst = master.get(startX, startY, xIncrement, yIncrement); 
  image(newFirst, startX, startY);
}

//the boolean flips which side of "threshold" the boxes are displayed on
void totalLessThan(int startX, int startY) {
  if (bTotal < threshold) {
    stroke(255, 0, 0, 40);
    noFill();
    //firstImageTile(startX, startY);
    rect(startX, startY, xIncrement, yIncrement);
  }
}

//the boolean flips which side of "threshold" the boxes are displayed on
void totalGreaterThan(int startX, int startY) {
  if (bTotal > threshold) {
    stroke(255, 0, 0, 40);
    noFill();
    //firstImageTile(startX, startY);
    rect(startX, startY, xIncrement, yIncrement);
  }
}

//cut apart each image in the folder
void dissect() {
  //find directory of sample images NOTE: it doesn't work well if the folder is in "data"
  File dir = new File(sketchPath, "../samples");
  if (dir.isDirectory()) {
    String[] contents = dir.list();
    images = new PImage[contents.length]; 
    imageNames = new String[contents.length]; 
    for (int i = 0; i < contents.length; i++) {

      // skip hidden files and folders starting with a dot, load .png files only
      if (contents[i].charAt(0) == '.') continue;

      //if the image isnt the master, continue to parse
      else if (contents[i].toLowerCase().endsWith(".png")) {
        File childFile = new File(dir, contents[i]);        
        images[imageCount] = loadImage(childFile.getPath());
        imageNames[imageCount] = childFile.getName();
        println(imageCount+" "+contents[i]+" "+childFile.getPath());
      } else if (contents[i].equals("master.png")) {
        int tileIndex = 0;

        //assign the current image a variable so its easier to reference
        PImage currentImage = images[imageCount];

        //this will get your cut-and-dry grid count along x and y
        int xDim = currentImage.width / xIncrement;
        int yDim = currentImage.height / yIncrement;

        //this test determines if there is a smaller grid leftover, in which case you still need to compute an mValue for it
        if (currentImage.width % xIncrement != 0) xDim++;
        if (currentImage.height % yIncrement != 0) yDim++;
        float [] mValues = new float[xDim*yDim];

        //run dissection on the master
        for (int x = 0; x < currentImage.width; x += xIncrement) {
          for (int y = 0; y < currentImage.height; y += yIncrement) {
            mTotal = 0;

            //count each tile
            tile(currentImage, x, y, xIncrement, yIncrement);
            mTotal = mTotal / resolution;

            //store average brightness for this tile in a master array
            mValues[tileIndex] = mTotal;
            println(mValues[tileIndex]);
            tileIndex++;
            println(tileIndex, "image #"+imageCount, imageNames[imageCount], x, y, mTotal);
          }
        }
      }

      //once the master file is dissected, move on to the samples
      int tileIndex = 0;
      
      //assign the current image a variable so its easier to reference
      PImage currentImage = images[imageCount];

      //this will get your cut-and-dry grid count along x and y
      int xDim = currentImage.width / xIncrement;
      int yDim = currentImage.height / yIncrement;

      //this test determines if there is a smaller grid leftover, in which case you still need to compute a bValue for it
      if (currentImage.width % xIncrement != 0) xDim++;
      if (currentImage.height % yIncrement != 0) yDim++;
      float [] bValues = new float[xDim*yDim];

      //run dissection on each sample image in the folder
      for (int x = 0; x < currentImage.width; x += xIncrement) {
        for (int y = 0; y < currentImage.height; y += yIncrement) {
          bTotal = 0;

          //count each tile
          tile(currentImage, x, y, xIncrement, yIncrement);
          bTotal = bTotal / resolution;

          //store average brightness for this tile in an array
          bValues[tileIndex] = bTotal;
          println(bValues[tileIndex]);
          tileIndex++;
          println(tileIndex, "image #"+imageCount, imageNames[imageCount], x, y, bTotal);
        }
      }
      imageCount++;
    }
  }
}


//trying to get the sketch to output a pdf of the onscreen result, even if its
//just the red grid lines
void saveGrid() {
  beginRecord(PDF, "grid_####.pdf");
  noFill();
  for (int x = 0; x < width; x += xIncrement) {
    for (int y = 0; y < height; y += yIncrement) {
      //tile(x, y, xIncrement, yIncrement);
      bTotal = bTotal / resolution;
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
    savePDF = true;
  }
  if (key == 'e' || key == 'E') {
    endRecord();
    savePDF = false;
  }
  if (key == 'd' || key == 'D') {
    dissect();
  }
}

