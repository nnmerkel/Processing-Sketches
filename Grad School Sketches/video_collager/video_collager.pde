import controlP5.*;
import java.util.Calendar;
import processing.video.*;
import java.io.File;


Capture cam;
ControlP5 cp5;

ArrayList<TileObject> t = new ArrayList<TileObject>();
ArrayList<PImage> directory = new ArrayList<PImage>();

//how often the program will resample a new still frame to source from, in milliseconds
int interval = 10000;
int xIncrement = 20;
int yIncrement = 20;
int tileCount;
int imageCount;

float resolution;
float bTotal;
float mTotal;

String directoryName = "";

boolean directorySet;

//r, g, b, h, s, b, c
boolean[] modes = new boolean[7];
int[] newValues;
TileObject[] m;
PImage[] images;
String[] imageNames;

void setup() {
  size(1080, 720);
  cp5 = new ControlP5(this);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  }

  // The camera can be initialized directly using an 
  // element from the array returned by list():
  cam = new Capture(this, cameras[0]);
  cam.start();
  setupGUI();
}


void draw() {
  if (!directorySet) {
    setDestination();
  }

  if (cam.available() == true) {
    cam.read();
  }

  //image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  set(0, 0, cam);

  //cut apart the current frame
  //runDissection();
}


void setDestination() {
  
  File f = new File("/Users/EAM/GitHub/Processing-Sketches//Grad School Sketches/video_collager/test");
  try {
    f.mkdir();
  } 
  catch(Exception e) {
    e.printStackTrace();
  }
  
  directorySet = true;
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
      if (modes[0]) {
        attr = red(c1);
      } else if (modes[1]) {
        attr = green(c1);
      } else if (modes[2]) {
        attr = blue(c1);
      } else if (modes[3]) {
        attr = hue(c1);
      } else if (modes[4]) {
        attr = saturation(c1);
      } else if (modes[5]) {
        attr = brightness(c1);
      } else if (modes[6]) {
        attr = (c1 >> 16 & 0xFF) + (c1 >> 8 & 0xFF) + (c1 & 0xFF);
      }
      bTotal += attr;
      mTotal += attr;
    }
  }
}


//object-oriented dissection
void dissectImage(PImage image) {
  int tileIndex = 0;

  //calculate the size of bValues array
  int xDim = image.width / xIncrement;
  int yDim = image.height / yIncrement;

  //we only need yDim and tileCount so the arraylist loop counts off the right number of tiles
  tileCount = xDim * yDim;

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
    t.add(new TileObject(tempX, tempY, tempSource, tempAvg, tempIndex));

    tileIndex++;
  }
}


void dissectMaster(PImage image) {
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

    tileIndex++;
  }
}


void runDissection() {
  //variable to time this function
  long startTime = System.nanoTime();

  //dissect the master image here, before we loop through the samples
  dissectMaster(cam);

  //reset the array so it can run more than once
  //also reset the ArrayList so tiles don't get reused and memory gets freed up
  imageCount = 0;
  t.clear();

  //reset resolution
  resolution = xIncrement * yIncrement;

  File dir = new File(directoryName);
  if (dir.isDirectory()) {
    String[] contents = dir.list();
    printArray(contents);

    int directoryLength = contents.length;
    images = new PImage[directoryLength];
    imageNames = new String[directoryLength];
    for (int i = 0; i < directoryLength; i++) {
      if (contents[i].charAt(0) == '.' ||
        !contents[i].toLowerCase().matches("^.*\\.(jpg|gif|png|jpeg)$")) {
        continue;
      } else {
        File childFile = new File(dir, contents[i]);
        images[imageCount] = loadImage(childFile.getPath());
        imageNames[imageCount] = childFile.getName();

        dissectImage(images[imageCount]);
      }
      imageCount++;
    }

    //if no file in the directory was an image, tell the user that nothing happened
    if (imageCount == 0) {
      //code for null
    }
  }
  println(t.size());

  //m and tx are the TileObject arrays
  findBestMatch(m, t);

  reconstruct();

  long endTime = System.nanoTime();
  long duration = (endTime - startTime)/1000000;
  println("\n" + "duration: " + duration + "\n");
}


//this function compares each value in the mValues array to every other value in the bValues array
//to find the closest possible match, then test display the tile image
void findBestMatch(TileObject masterArray[], ArrayList<TileObject> brightness) {
  int bestIndex = 0;
  int valueCounter = 0;
  float tolerance = 0.005;

  //if using color as the mode, we are dealing with larger ints so we can bring the tolerance up
  if (modes[6]) tolerance = 1f;

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

      //"close enough" -- evan merkel 2k16
      if (bestDiff <= tolerance) {
        break;
      }
    }
    valueCounter++;
  }
}


//write the new image to a file
void reconstruct() {
  //load the 1px images to sub in for near-black and near-white
  PImage black = loadImage("black.png");
  PImage white = loadImage("white.png");

  int xDim = m[0].sourceImage.width / xIncrement;

  //shit works, but PGraphics gets grumpy
  //see https://github.com/nnmerkel/Processing-Sketches/issues/14
  //int newWidth = m[0].sourceImage.width - (m[0].sourceImage.width % xIncrement);
  //int newHeight = m[0].sourceImage.height - (m[0].sourceImage.height % yIncrement);
  //println("xDim", xDim, newWidth, newHeight);

  //PGraphics savedImage = createGraphics(newWidth, newHeight);

  PGraphics savedImage = createGraphics(m[0].sourceImage.width, m[0].sourceImage.height);
  savedImage.beginDraw();
  savedImage.noStroke();
  savedImage.noFill();

  for (int i = 0; i < m.length; i++) {    
    TileObject newTile = t.get(newValues[i]);

    int xWalker = (i % xDim) * xIncrement;
    int yWalker = int(i / xDim) * yIncrement;

    int tempX = newTile.x;
    int tempY = newTile.y;

    PImage tileInstance = newTile.sourceImage.get(tempX, tempY, xIncrement, yIncrement);

    //if the tiles is almost black, make it true black to enhance quality
    if (newTile.avgAttribute <= 1.0) {
      tileInstance.set(xWalker, yWalker, black);
    }

    //if it's almost white, make it white
    if (newTile.avgAttribute >= 254.0) {
      tileInstance.set(xWalker, yWalker, white);
    }

    savedImage.image(tileInstance, xWalker, yWalker);
  }

  savedImage.endDraw();
  savedImage.save(timestamp() + ".png");
}


String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}