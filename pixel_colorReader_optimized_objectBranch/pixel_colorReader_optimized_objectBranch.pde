/** Photomosaic generator
 *  
 *  
 *  
 */

//----------------libraries
import processing.pdf.*;
import controlP5.*;
import java.util.Calendar;

ControlP5 cp5;

PGraphics savedImage;

PFont font, monospace;

ArrayList<TileObject> tx = new ArrayList<TileObject>();

TileObject [] m;

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
boolean brightness = true;
boolean red, green, blue, hue, saturation;
float bTotal = 0;
float mTotal = 0;
float[] bValues;
float[] mValues;
int[] newValues;
String masterImageObject;
String samplesPath;

//-------------------block size
int xIncrement = 50;
int yIncrement = 50;
int resetX, resetY;
int tileCount;
int resolution;

//--------------------command array strings and constants
final String [] COMMAND_ARRAY = new String[] {
  "Please select the image from which you want to make a photomoasic.", 
  "Please select a folder of images from which to sample.", 
  "Set options for the photomosaic.", 
  "Press \"Dissect\" to continue.", 
  "Window was closed or the user hit cancel.", 
  "Frame saved", 
  "Operation complete", 
  "Dissecting…"
};
final int SELECT_MASTER = 0;
final int SELECT_SAMPLES = 1;
final int SET_OPTIONS = 2;
final int DISSECT = 3;
final int WINDOW_CANCELLED = 4;
final int FRAME_SAVED = 5;
final int COMPLETE = 6;
final int DISSECTING = 7;
String currentCommand = COMMAND_ARRAY[SELECT_MASTER];


void setup() {
  //size(800, 800);
  fullScreen();
  pixelDensity(2);
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

  fill(242);
  rect(0, 0, width, height);

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
    image(loadingGif, (width-guiWidth-loadingSize)/2, (height-loadingSize)/2, loadingSize, loadingSize);
  }

  //draw the command line without recording it
  fill(50);
  rect(0, height-30, width, height-30);
  //fill(64, 226, 72); //command line green
  fill(170);
  textFont(monospace);
  textSize(12);
  text(">  " + currentCommand, 10, height-10);
  noFill();

  if (savePDF) {
    endRecord();
    println("pdf saved");
    savePDF = false;
    exit();
  }

  if (reconstruct) {
    reconstruct2();
    noLoop();
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
  float attr = 0;
  for (int x = startX; x < tileX; x++) {
    for (int y = startY; y < tileY; y++) {
      color c1 = theImage.get(x, y);
      if (brightness) {
        attr = brightness(c1);
      } else if (red) {
        attr = red(c1);
      } else if (green) {
        attr = green(c1);
      } else if (blue) {
        attr = blue(c1);
      } else if(hue) {
        attr = hue(c1);
      } else if (saturation) {
        attr = saturation(c1);
      }
      bTotal = bTotal + attr;
      mTotal = mTotal + attr;
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
  //variable to time this function
  long startTime = System.nanoTime();

  inProgress = true;
  reconstruct = false;

  currentCommand = COMMAND_ARRAY[DISSECTING];

  //dissect the master image here, before we loop through the samples
  PImage masterTemp = loadImage(masterImageObject);
  experimentMaster(masterTemp);

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

      // 1. skip hidden files, if contained in the samples folder
      // 2. also skip non-image format files
      // 3. skip the master file, if contained in the samples folder
      if (contents[i].charAt(0) == '.' ||                                         //1
        !contents[i].toLowerCase().matches("^.*\\.(jpg|gif|png|jpeg)$") ||      //2
        masterImageObject.endsWith(contents[i])) {                              //3
        continue;
      } else {
        File childFile = new File(dir, contents[i]);
        images[imageCount] = loadImage(childFile.getPath());
        imageNames[imageCount] = childFile.getName();
        println(imageCount, contents[i]);
        currentCommand = imageCount + " " + contents[i];
        //the function for actual dissection
        experiment(images[imageCount]);
      }
      imageCount++;
    }
  }
  println(tx.size());
  //m and t are the TileObject arrays
  findBestMatch(m, tx);
  dissect = false;
  inProgress = false;
  currentCommand = COMMAND_ARRAY[COMPLETE];

  //these lines are to time the dissect function
  //------------- best value so far: 4895 for 55 images @200x200
  //------------- best value so far: 4882 for 55 images @100x100
  //------------- best value so far: 4862 for 55 images @50x50
  //------------- best value so far: 4739 for 55 images @20x20
  long endTime = System.nanoTime();
  long duration = (endTime - startTime)/1000000;
  println("\n" + "duration " + duration + "\n");
  reconstruct = true;
}


//experiemental object-oriented dissection
void experiment(PImage image) {
  int tileIndex = 0;

  //calculate the size of bValues array
  int xDim = image.width / xIncrement;
  int yDim = image.height / yIncrement;

  tileCount = xDim * yDim;
  //t = new TileObject[tileCount];

  for (int i = 0; i < tileCount; i++) {
    //initialize the variables for each tile
    int tempX = (i % xDim) * xIncrement;
    int tempY = int(i / xDim) * yIncrement;
    PImage tempSource = image;
    int tempIndex = tileIndex;

    //the average brightness starts at 0
    bTotal = 0;

    //count each tile
    tile(image, tempX, tempY, xIncrement, yIncrement);
    bTotal /= resolution;
    float tempAvg = bTotal;
    tx.add(new TileObject(tempX, tempY, tempSource, tempAvg, tempIndex));

    //store average brightness for this tile in a master array
    //println("bValues " + bValues[tileIndex] + "\n" + "avgAttribute " + t[i].avgAttribute);
    //bValues[tileIndex] = t[i].avgAttribute;//<------------------------------encountering cp5 issue here
    tileIndex++;
  }
}


void experimentMaster(PImage image) {
  int tileIndex = 0;

  //calculate the size of bValues array
  int xDim = image.width / xIncrement;
  int yDim = image.height / yIncrement;

  tileCount = xDim * yDim;
  m = new TileObject[tileCount];

  for (int i = 0; i < tileCount; i++) {
    //initialize the variables for each tile
    int tempX = (i % xDim) * xIncrement;
    int tempY = int(i / xDim) * yIncrement;
    PImage tempSource = image;
    int tempIndex = tileIndex;

    //the average brightness starts at 0
    mTotal = 0;

    //count each tile
    tile(image, tempX, tempY, xIncrement, yIncrement);
    mTotal /= resolution;
    float tempAvg = mTotal;
    m[i] = new TileObject(tempX, tempY, tempSource, tempAvg, tempIndex);

    //store average brightness for this tile in a master array
    //println("bValues " + bValues[tileIndex] + "\n" + "avgAttribute " + t[i].avgAttribute);
    //bValues[tileIndex] = t[i].avgAttribute;//<------------------------------encountering cp5 issue here
    tileIndex++;
  }
}


//-----------------------DEPRECATED---------------------//
//im only keeping this for the leftover computations
//cut apart all the sample images
void dissectImage(PImage image) {
  println("dissecting", imageNames[imageCount], "now");
  int tileIndex = 0;

  //calculate the size of bValues array
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
    //println(tileIndex, imageNames[imageCount], bTotal);
    tileIndex++;
  }
}


//this function compares each value in the mValues array to every other value in the bValues array
//to find the closest possible match, then test display the tile image
void findBestMatch(TileObject masterArray[], ArrayList<TileObject> brightness) {
  int bestIndex = 0;
  int valueCounter = 0;
  TileObject tempTile, otherTile;
  newValues = new int[masterArray.length];
  for (int i = 0; i < masterArray.length; i++) {
    tempTile = brightness.get(i);
    float bestDiff = abs(masterArray[i].avgAttribute - tempTile.avgAttribute);
    for (int j = 0; j < brightness.size(); j++) {
      otherTile = brightness.get(j);
      float diff = abs(masterArray[i].avgAttribute - otherTile.avgAttribute);
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
  //printArray(newValues);
}


void reconstruct2() {
  int xDim = m[0].sourceImage.width / xIncrement;
  savedImage = createGraphics(m[0].sourceImage.width, m[0].sourceImage.height);
  savedImage.beginDraw();
  savedImage.noStroke();
  savedImage.noFill();
  for (int i = 0; i < m.length; i++) {    
    int indexToNewTile = newValues[i];
    TileObject newTile = tx.get(indexToNewTile);

    int xWalker = (i % xDim) * xIncrement;
    int yWalker = int(i / xDim) * yIncrement;

    int tempX = newTile.x;
    int tempY = newTile.y;

    PImage tileInstance = newTile.sourceImage.get(tempX, tempY, xIncrement, yIncrement);
    savedImage.image(tileInstance, xWalker, yWalker);
  }
  savedImage.endDraw();
  savedImage.save(timestamp() + ".png");
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
  }
  if (key == 'f' || key == 'F') {
    reconstruct = true;
    //reconstruct(images[1], 47, startX, startY, tileCount);
    //reconstruct(images[], bestIndex[i], x, y);
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}