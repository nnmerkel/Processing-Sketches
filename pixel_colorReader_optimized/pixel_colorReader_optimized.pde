import processing.pdf.*;
import controlP5.*;

ControlP5 cp5;

PImage master;
PImage[] images;
String[] imageNames;
int imageCount;

boolean switchStyle = false;
boolean savePDF = false;
boolean reconstruct = false;
float bTotal = 0;
float mTotal = 0;
float[] bValues;
float[] mValues;
int[] newValues;

//block size
int xIncrement = 90;
int yIncrement = 90;
int resetX, resetY;
int tileCount;
float resolution;
float threshold = 120;

void setup() {
  size(929, 1331);
  //load master image to be collaged
  master = loadImage("master.jpg");

  //control GUI
  cp5 = new ControlP5(this);
  Group g2 = cp5
    .addGroup("g2")
    .setPosition(10, 20)
      .setWidth(200)
        .setBackgroundColor(color(0, 80))
          .setBackgroundHeight(106)
            .setLabel("Menu");
  //cp5.addSlider("threshold").setPosition(4, 4).setSize(192, 20).setRange(0, 255).setGroup(g2).setValue(120);
  //make sure xIncrement and yIncrement are never set to 0 (a box cannot have 0 width) 
  cp5.addSlider("xIncrement")
    .setPosition(4, 28)
      .setSize(192, 20)
        .setRange(1, 200)
          .setGroup(g2)
            .setValue(100);
  cp5.addSlider("yIncrement")
    .setPosition(4, 52)
      .setSize(192, 20)
        .setRange(1, 200)
          .setGroup(g2)
            .setValue(100);
  //cp5.addToggle("switchStyle").setPosition(4, 76).setSize(16, 16).setCaptionLabel("greater than").setGroup(g2);
  //selectFolder("Select a folder to process:", "folderSelected");
}

void draw() {
  //resolution must be defined for each frame
  //fill(205);
  //rect(0, 0, width, height);
  noFill();
  resolution = xIncrement*yIncrement;
  resetX = xIncrement;
  resetY = yIncrement;
  if (savePDF) beginRecord(PDF, "grid_####.pdf");
  noStroke();
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
    println("pdf saved");
    exit();
  }
}

//sample the master image
void tile(PImage theImage, int startX, int startY, int tileSizeX, int tileSizeY) {
  resolution = tileSizeX * tileSizeY;
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

//these two functions should actually tile the images onto one another - UNUSED
void firstImageTile(int startX, int startY) {
  PImage newFirst = master.get(startX, startY, xIncrement, yIncrement); 
  image(newFirst, startX, startY);
}

//the boolean flips which side of "threshold" the boxes are displayed on - UNUSED
void totalLessThan(int startX, int startY) {
  if (bTotal < threshold) {
    stroke(255, 0, 0, 40);
    noFill();
    //firstImageTile(startX, startY);
    rect(startX, startY, xIncrement, yIncrement);
  }
}

//the boolean flips which side of "threshold" the boxes are displayed on - UNUSED
void totalGreaterThan(int startX, int startY) {
  if (bTotal > threshold) {
    stroke(255, 0, 0, 40);
    noFill();
    //firstImageTile(startX, startY);
    rect(startX, startY, xIncrement, yIncrement);
  }
}

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
  }
}

//cut apart each image in the folder
void dissect() {
  //find directory of sample images NOTE: it doesn't work well if the folder is in "data"
  File dir = new File("/Users/EAM/GitHub/Processing-Sketches/samples2");
  if (dir.isDirectory()) {
    String[] contents = dir.list();
    printArray(contents);

    //check for hidden files here so that the loop runs for the appropriate length
    int directoryLength = contents.length;
    if (contents[0].equals(".DS_Store")) //directoryLength--;
      println("directoryLength =", directoryLength);

    images = new PImage[directoryLength]; 
    imageNames = new String[directoryLength]; 
    for (int i = 0; i < directoryLength; i++) {
      // skip hidden files, especially .DS_Store
      if (contents[i].charAt(0) == '.') continue;
      else {
        File childFile = new File(dir, contents[i]);
        //this next line is also a problem in that if you try to run dissection twice without quitting, you will get the same error
        images[imageCount] = loadImage(childFile.getPath()); //PROBLEM LINE <---------ArrayIndexOutOfBoundsException: 3
        imageNames[imageCount] = childFile.getName();
        println(imageCount, contents[i], childFile.getPath());
      }
      if (contents[i].toLowerCase().startsWith("master")) {
        dissectMaster(images[imageCount]);
      } else {
        dissectImage(images[imageCount]);
      }
      imageCount++;
    }
  }
}



//cut apart all the sample images
void dissectImage(PImage image) {
  println("dissecting", imageNames[imageCount], "now");
  int tileIndex = 0;

  //this will get your cut-and-dry grid count along x and y
  int xDim = image.width / xIncrement;
  int yDim = image.height / yIncrement;

  //this test determines if there is a smaller grid leftover, in which case you still need to compute a bValue for it
  int xLeftover = image.width % xIncrement;
  int yLeftover = image.width % yIncrement;
  if (xLeftover != 0) {
    xDim++;
  }
  if (yLeftover != 0) {
    yDim++;
  }

  //now we can define the grid size
  tileCount = xDim * yDim;

  //each tile gets its own bValue
  bValues = new float[tileCount];
  println("the array is", xDim, "by", yDim);
println("newX" + resetX);
  //run the test again but with correct tileCount to limit the loop
  for (int i = 0; i < tileCount; i++) {
    if (xLeftover != 0) {
      xIncrement = xLeftover;
      println("xIncrement =", xIncrement);
    } else {
      xIncrement = resetX;
    }
    if (yLeftover != 0) {
      yIncrement = yLeftover;
      println("yIncrement =", yIncrement);
    } else {
      yIncrement = resetY;
    }
    println(xIncrement);

    int x, y;
    //get the coordinates of the top-left corner of every tile
    x = (i % xDim) * xIncrement;
    y = int(i / xDim) * yIncrement;

    //run the dissection itself
    bTotal = 0;

    //count each tile
    tile(image, x, y, xIncrement, yIncrement);
    bTotal = bTotal / resolution;

    //store average brightness for this tile in a master array
    bValues[tileIndex] = bTotal; //PROBLEM LINE <----------------------------ArrayIndexOutOfBoundsException: [num]
    println(tileIndex, "image #" + imageCount, imageNames[imageCount], x, y, bTotal);
    tileIndex++;
  }
}


//run the dissection on the master. identical to dissectImage except the values
//get put into a separate array for comparison later
void dissectMaster(PImage image) {
  println("dissecting the master now");
  int tileIndex = 0;
  
  //this will get your cut-and-dry grid count along x and y
  int xDim = image.width / xIncrement;
  int yDim = image.height / yIncrement;

  //this test determines if there is a smaller grid leftover, in which case you still need to compute a bValue for it
  int xLeftover = image.width % xIncrement;
  int yLeftover = image.width % yIncrement;
  if (xLeftover != 0) {
    xDim++;
  }
  if (yLeftover != 0) {
    yDim++;
  }

  //now we can define the grid size
  tileCount = xDim * yDim;

  //each tile gets its own bValue
  mValues = new float[tileCount];
  println("the array is", xDim, "by", yDim);

  //run the test again but with correct tileCount to limit the loop
  for (int i = 0; i < tileCount; i++) {
    if (xLeftover != 0) {
      xIncrement = xLeftover;
      println("xIncrement =", xIncrement);
    } else {
      xIncrement = resetX;
    }
    if (yLeftover != 0) {
      yIncrement = yLeftover;
      println("yIncrement =", yIncrement);
    } else {
      yIncrement = resetY;
    }

    int x, y;
    //get the coordinates of the top-left corner of every tile
    x = (i % xDim) * xIncrement;
    y = int(i / xDim) * yIncrement;

    //run the dissection itself
    mTotal = 0;

    //count each tile
    tile(image, x, y, xIncrement, yIncrement);
    mTotal = mTotal / resolution;

    //store average brightness for this tile in a master array
    mValues[tileIndex] = mTotal; //PROBLEM LINE <----------------------------ArrayIndexOutOfBoundsException: [num]
    println(tileIndex, "image #" + imageCount, imageNames[imageCount], x, y, mTotal);
    tileIndex++;
  }
  //printArray(mValues);
  findBestMatch(mValues, bValues);
  reconstruct(images[1], tileIndex, xDim, yDim, tileCount);
  println(images[1], tileIndex, xDim, yDim, tileCount);
}



//this function compares each value in the mValues array to every other value in the bValues array
//to find the closest possible match, then test display the tile image
void findBestMatch(float masterArray[], float brightnessArray[]) {
  int bestIndex = 0;
  int valueCounter = 0;
  newValues = new int[masterArray.length];
  for (int i = 0; i < masterArray.length; i++) {
    float bestDiff = abs(masterArray[i] - brightnessArray[0]);
    for (int j = 0; j < brightnessArray.length; j++) {
      float diff = abs(masterArray[i] - brightnessArray[j]);
      if (diff <= bestDiff) {//check back here on the less than/equal to tiebreaker
        //here’s a potential match; don’t stop now as there could be a better match later
        bestIndex = j;
        bestDiff = diff;
        //println(bestIndex, bestDiff, masterArray[i], brightnessArray[j]);
      }
      //make a new array here to store each bestIndex, then extract those values in a different function and display them
      newValues[valueCounter] = bestIndex;
    }
    valueCounter++;
  }
  printArray(newValues);
  //println(bestIndex, mValues[bestIndex], bValues[bestIndex]);
}



//after we take care of the files, reconstruct the images
void reconstruct(PImage theImage, int tileIndex, int xDim, int yDim, int tileCount) {  
  //actual loop
  int x, y;
  for (int i = 0; i < tileCount; i++) {
    //get the coordinates of the top-left corner of every tile
    x = (i % xDim) * xIncrement;
    y = int(i / xDim) * yIncrement;
    PImage sampleTile = theImage.get(x, y, xIncrement, yIncrement);
    image(sampleTile, x, y);
  }
}

//trying to get the sketch to output a pdf of the onscreen result, even if its - UNUSED, see draw()
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
  if (key == 'f' || key == 'F') {
    reconstruct = true;
    //reconstruct(images[1], 47, startX, startY, tileCount);
    //reconstruct(images[], bestIndex[i], x, y);
  }
}