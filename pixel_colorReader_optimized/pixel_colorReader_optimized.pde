/**
 *  
 *  
 *  
 *  
 *  
 *  
 *  
 *  
 *  
 *  
 */

//----------------libraries
import processing.pdf.*;
import controlP5.*;

ControlP5 cp5;

PFont font, monospace;

PImage master;
PImage loadingGif;
PImage[] images;
String[] imageNames;
int imageCount;

boolean savePDF = false;
boolean reconstruct = false;
boolean inProgress = false;
boolean selectSamples = false;
boolean selectMaster = false;
boolean dissect = false;
float bTotal = 0;
float mTotal = 0;
float[] bValues;
float[] mValues;
int[] newValues;
String masterImageObject;
String samplesPath;

//-------------------block size
int xIncrement = 100;
int yIncrement = 100;
int resetX, resetY;
int tileCount;
float resolution;

//--------------------command array strings and constants
final String [] COMMAND_ARRAY = new String[] {
  "Please select the image from which you want to make a photomoasic.", 
  "Please select a folder of images from which to sample.", 
  "Set options for the photomosaic.", 
  "Press \"Dissect\" to continue.", 
  "Window was closed or the user hit cancel.", 
  "Frame saved"
};
final int SELECT_MASTER = 0;
final int SELECT_SAMPLES = 1;
final int SET_OPTIONS = 2;
final int DISSECT = 3;
final int WINDOW_CANCELLED = 4;
final int FRAME_SAVED = 5;
String currentCommand = COMMAND_ARRAY[SELECT_MASTER];


void setup() {
  fullScreen();
  pixelDensity(2);
  //load master image to be collaged
  master = loadImage("master.jpg");
  loadingGif = loadImage("loading-gif.gif");
  cp5 = new ControlP5(this);
  font = createFont("UniversLTStd-UltraCn.otf", 14);
  monospace = createFont("Consolas.ttf", 14);
  textFont(font); 

  setupGUI();
}


void draw() {
  //maintain the workflow, select files first
  //THE WORK MUST FLOW
  if (selectMaster) {
    selectInput("Select a master image:", "masterSelected");
    selectMaster = false;
  }
  if (selectSamples) {
    selectFolder("Select a folder of sample images to process:", "folderSelected");
    selectSamples = false;
  }

  //offset the workspace
  pushMatrix();
  translate(guiWidth, 0);

  if (savePDF) beginRecord(PDF, "grid_####.pdf");

  fill(230);
  rect(0, 0, width, height);

  //draw the command line without recording it
  fill(50);
  rect(0, height-30, width, height-30);
  //fill(64, 226, 72); //command line green
  fill(170);
  textFont(monospace);
  textSize(12);
  text(">   " + currentCommand, 10, height-10);
  noFill();

  //once a master image is chosen, display it every frame
  if (masterImageObject != null) {
    PImage master = loadImage(masterImageObject);
    imageMode(CENTER);
    image(master, (width-guiWidth)/2, height/2);
  }
  //reset the image drawing mode
  imageMode(CORNER);

  //resolution must be defined for each frame
  resolution = xIncrement*yIncrement;

  //preserve initial increment values
  resetX = xIncrement;
  resetY = yIncrement;

  //draw the tiling grid
  for (int x = 0; x < width; x += xIncrement) {
    for (int y = 0; y < height; y += yIncrement) {
      stroke(255, 0, 0, 40);
      noFill();
      rect(x, y, xIncrement, yIncrement);
    }
  }

  int loadingSize = 75;
  //display the proper box size and the loading gif
  if (inProgress) {
    fill(0, 50);
    rect(0, 0, width, height);
    image(loadingGif, (width+guiWidth-loadingSize)/2, (height-loadingSize)/2, loadingSize, loadingSize);
  }

  if (savePDF) {
    savePDF = false;
    endRecord();
    println("pdf saved");
    exit();
  }

  popMatrix();
}


//the actual counting function
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


//callback function for the samples
void folderSelected(File selection) {
  if (selection == null) {
    currentCommand = COMMAND_ARRAY[WINDOW_CANCELLED];
  } else {
    //unlock the rest of the buttons
    setLock(cp5.getController("xIncrement"), false);
    setLock(cp5.getController("yIncrement"), false);
    setLock(cp5.getController("dissect"), false);
    samplesPath = selection.getAbsolutePath();
    currentCommand = COMMAND_ARRAY[SET_OPTIONS];
  }
}


//callback function for the master image selection
void masterSelected(File selection) {
  if (selection == null) {
    currentCommand = COMMAND_ARRAY[WINDOW_CANCELLED];
  } else {
    //unlock the sample selection
    setLock(cp5.getController("selectSamples"), false);
    masterImageObject = selection.getAbsolutePath();
    currentCommand = COMMAND_ARRAY[SELECT_SAMPLES];
  }
}


//cut apart each image in the folder
void dissect() {

  //reset the array so it can run more than once
  imageCount = 0;

  //find directory of sample images NOTE: it doesn't work well if the folder is in "data"
  File dir = new File(samplesPath);
  if (dir.isDirectory()) {
    String[] contents = dir.list();
    printArray(contents);

    int directoryLength = contents.length;

    images = new PImage[directoryLength];
    imageNames = new String[directoryLength];
    //check for hidden files here so that the loop runs for the appropriate length
    for (int i = 0; i < directoryLength; i++) {

      // skip hidden files, especially .DS_Store (Mac)
      if (contents[i].charAt(0) == '.') continue;
      else if (!contents[i].equals(masterImageObject)){
        File childFile = new File(dir, contents[i]);
        images[imageCount] = loadImage(childFile.getPath());
        imageNames[imageCount] = childFile.getName();
        println(imageCount, contents[i], childFile.getPath());
        currentCommand = imageCount + " " + contents[i] + " " + childFile.getPath();
        dissectImage(images[imageCount]);
      }
      imageCount++;
    }
  }
  dissect = false;
  inProgress = false;
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
  int yLeftover = image.height % yIncrement;
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
  //run the test again but with correct tileCount to limit the loop
  for (int i = 0; i < tileCount; i++) {
    if (xLeftover != 0) {
      //xIncrement = xLeftover;
      //println("xIncrement =", xIncrement);
    } else {
      //xIncrement = resetX;
    }
    if (yLeftover != 0) {
      //yIncrement = yLeftover;
      //println("yIncrement =", yIncrement);
    } else {
      //yIncrement = resetY;
    }

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
    bValues[tileIndex] = bTotal;
    println(tileIndex, imageNames[imageCount], bTotal);
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
  int yLeftover = image.height % yIncrement;
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
      //xIncrement = xLeftover;
      //println("xIncrement =", xIncrement);
    } else {
      //xIncrement = resetX;
    }
    if (yLeftover != 0) {
      //yIncrement = yLeftover;
      //println("yIncrement =", yIncrement);
    } else {
      //yIncrement = resetY;
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
    mValues[tileIndex] = mTotal;
    println(tileIndex, imageNames[imageCount], mTotal);
    tileIndex++;
  }

  //run the test
  findBestMatch(mValues, bValues);
  //reconstruct(images[1], tileIndex, xDim, yDim, tileCount);
}


//this function compares each value in the mValues array to every other value in the bValues array
//to find the closest possible match, then test display the tile image
void findBestMatch(float masterArray[], float brightnessArray[]) {
  int bestIndex = 0;
  int valueCounter = 0;
  newValues = new int[masterArray.length];
  for (int i = 0; i < masterArray.length; i++) {
    float bestDiff = abs(masterArray[i] - brightnessArray[0]); // <-------------------NullPointerException because master image is dissected first
    for (int j = 0; j < brightnessArray.length; j++) {
      float diff = abs(masterArray[i] - brightnessArray[j]);
      if (diff <= bestDiff) {
        //here’s a potential match; don’t stop now as there could be a better match later
        bestIndex = j;
        bestDiff = diff;
      }
      //make a new array here to store each bestIndex, then extract those values in a different function and display them
      newValues[valueCounter] = bestIndex;
    }
    valueCounter++;
  }
  printArray(newValues);
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


void keyReleased() {
  if (key == 's' || key == 'S') {
    saveFrame("frame_####.png");
    currentCommand = COMMAND_ARRAY[FRAME_SAVED];
  }
  if (key == 'p' || key == 'P') {
    savePDF = true;
  }
  if (key == 'e' || key == 'E') {
    endRecord();
    savePDF = false;
  }
  if (key == 'd' || key == 'D') {
    inProgress = true;
    if (samplesPath != null) {
      dissect = true;
    } else {
      println("Please select a folder of images to sample");
    }
  }
  if (key == 'f' || key == 'F') {
    reconstruct = true;
    //reconstruct(images[1], 47, startX, startY, tileCount);
    //reconstruct(images[], bestIndex[i], x, y);
  }
}