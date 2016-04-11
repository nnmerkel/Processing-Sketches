/** Photomosaic generator
 *  
 *  
 *  
 */

//----------------libraries
import processing.pdf.*;
import controlP5.*;
import java.util.Calendar;
import java.util.Arrays;

//secondary image classes
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.color.ColorSpace;

//the glorious, glorious sauce:
//https://github.com/drewnoakes/metadata-extractor
import com.drew.metadata.Metadata;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.imaging.jpeg.JpegMetadataReader;
import com.drew.imaging.jpeg.JpegProcessingException;
import com.drew.imaging.jpeg.JpegSegmentMetadataReader;
import com.drew.metadata.exif.ExifReader;
import com.drew.metadata.iptc.IptcReader;

ControlP5 cp5;
PGraphics savedImage;
PFont font, monospace;
ArrayList<TileObject> tx = new ArrayList<TileObject>();
TileObject [] m;
PImage master;
PImage[] images;
String[] imageNames;

boolean savePDF = false;
boolean inProgress = false;
boolean selectSamples = false;
boolean selectMaster = false;
boolean dissect = false;
boolean[] modes = new boolean[7]; //r, g, b, h, s, b, c
float bTotal = 0;
float mTotal = 0;
int scaleFactor = 1;
float[] mValues;
int[] newValues;
int imageCount;
String masterImageObject;
String samplesPath;

//-------------------block size
int xIncrement = 50;
int yIncrement = 50;
int tileCount;
int resolution;

//--------------------command array strings and constants
final String [] COMMAND_ARRAY = new String[] {
  "Please select the image from which you want to make a photomosaic", 
  "Please select a folder of sample images", 
  "Set options for the photomosaic", 
  "Press \"Dissect\" to continue", 
  "Window was closed or the user hit cancel", 
  "Frame saved", 
  "Operation complete", 
  "Dissecting...", 
  "Please select a sampling mode to continue", 
  "Matching tiles to get the best fit...", 
  "The file you have selected is not an image. Please select a .jpg, .png, or .gif"
};
final static int SELECT_MASTER = 0;
final static int SELECT_SAMPLES = 1;
final static int SET_OPTIONS = 2;
final static int DISSECT = 3;
final static int WINDOW_CANCELLED = 4;
final static int FRAME_SAVED = 5;
final static int COMPLETE = 6;
final static int DISSECTING = 7;
final static int PICK_MODE = 8;
final static int NOW_MATCHING = 9;
final static int NOT_AN_IMAGE = 10;
String currentCommand = COMMAND_ARRAY[SELECT_MASTER];


void setup() {
  size(1280, 720);
  pixelDensity(2);
  cp5 = new ControlP5(this);
  font = createFont("UniversLTStd-UltraCn.otf", 12);
  monospace = createFont("Consolas.ttf", 14);
  textFont(font); 
  setupGUI();

  //experimental code here
  File file = new File("/Users/EAM/Desktop/cmyktest.jpg");
  try {
    Metadata metadata = ImageMetadataReader.readMetadata(file);

    //Directory directory2 = metadata.getFirstDirectoryOfType(ExifSubIFDDirectory.class);
    //String orientation = directory2.getDescription(directory2.TAG_ORIENTATION);

    ExifSubIFDDirectory directory = metadata.getFirstDirectoryOfType(ExifSubIFDDirectory.class);
    String colorSpace = directory.getDescription(directory.TAG_COLOR_SPACE);

    println(colorSpace);
    printx(metadata);
  } 
  catch (ImageProcessingException e) {
    println(e);
  } 
  catch (IOException e) {
    println(e);
  }
  println(isCMYK("/Users/EAM/Desktop/cmyktest.jpg"));
}


//EXPERIMENTAL: function to print image metadata
void printx(Metadata metadata) {
  System.out.println("-------------------------------------");
  for (Directory directory : metadata.getDirectories()) {

    for (Tag tag : directory.getTags()) {
      System.out.println(tag);
    }

    if (directory.hasErrors()) {
      for (String error : directory.getErrors()) {
        System.err.println("ERROR: " + error);
      }
    }
  }
}


boolean isCMYK(String filename) {
  boolean result = false;
  BufferedImage img = null;
  try {
    img = ImageIO.read(new File(filename));
  }
  catch (IOException e) {
    System.out.println(e.getMessage() + ": " + filename);
  }
  if (img != null) {
    int colorSpaceType = img.getColorModel().getColorSpace().getType();
    result = colorSpaceType == ColorSpace.TYPE_CMYK;
  }
  return result;
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
    int workspaceWidth = width-guiWidth;
    float widthDiff = (float)workspaceWidth/(float)master.width;
    float heightDiff = (float)height/(float)master.height;
    imageMode(CENTER);

    //dynamically size the master image
    if (widthDiff < 1 && heightDiff < 1) {
      //wider and taller than window
      float smallerDiff = widthDiff - heightDiff;
      if (smallerDiff > 0) {
        //needs to be fit to height
        image(master, workspaceWidth/2, height/2, master.width * heightDiff, master.height * heightDiff);
      } else {
        //needs to be fit to width
        image(master, workspaceWidth/2, height/2, master.width * widthDiff, master.height * widthDiff);
      }
    } else if (widthDiff < 1) {
      //wider than window
      image(master, workspaceWidth/2, height/2, master.width * widthDiff, master.height * widthDiff);
    } else if (heightDiff < 1) {
      //taller than window
      image(master, workspaceWidth/2, height/2, master.width * heightDiff, master.height * heightDiff);
    } else {
      //if it fits already
      image(master, workspaceWidth/2, height/2);
    }
  }

  //reset the image drawing mode
  imageMode(CORNER);

  //resolution must be defined for each frame
  resolution = xIncrement*yIncrement;

  //draw the tiling grid
  stroke(255, 0, 0, 80);
  noFill();
  for (int x = 0; x < width; x += xIncrement) {
    line(x, 0, x, height);
  }
  for (int y = 0; y < height; y += yIncrement) {
    line(0, y, width, y);
  }

  //display the proper box size and the loading gif
  if (inProgress) {
    fill(0, 100);
    rect(0, 0, width, height);
    progressWheel((width-guiWidth)/2, height/2);
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

  popMatrix();
  
  updateGUI();
}


//progress display function
void progressWheel(int centerX, int centerY) {
  int lineCount = 10;
  pushMatrix();
  translate(centerX, centerY);
  rotate(radians((frameCount * (360/lineCount)) % 360));
  for (int j = 0; j < 360; j += 360/lineCount) {
    stroke(((float)j/360)*255);
    strokeWeight(4);
    strokeCap(ROUND);
    float startX = cos(radians(j))*10;
    float startY = sin(radians(j))*10;
    float endX = cos(radians(j))*25;
    float endY = sin(radians(j))*25;
    line(startX, startY, endX, endY);
  }
  popMatrix();
  noStroke();
  strokeWeight(1);
}


//this checks the modes[] array to make sure user selected a sampling method
boolean isAllFalse(boolean[] array) {
  for (boolean b : array) if (b) return false;
  return true;
}


//check if an image contains a transparent pixel
boolean isTransparent(PImage img) {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int pixel = img.get(x, y);
      if ((pixel>>24) == 0x00 ) {
        return true;
      }
    }
  }
  return false;
}


//convert transparency to white background
PImage drawWhite(PImage img) {
  PGraphics p = createGraphics(img.width, img.height);
  p.beginDraw();
  p.background(255);
  p.image(img, 0, 0);
  p.endDraw();
  img = p;
  return img;
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
    setLock(cp5.getController("red"), false);
    setLock(cp5.getController("green"), false);
    setLock(cp5.getController("blue"), false);
    setLock(cp5.getController("hue"), false);
    setLock(cp5.getController("saturation"), false);
    setLock(cp5.getController("brightness"), false);
    setLock(cp5.getController("color"), false);
    setLock(cp5.getController("dissect"), false);
    samplesPath = selection.getAbsolutePath();
    currentCommand = COMMAND_ARRAY[SET_OPTIONS];
  }
}


//callback function for the master image selection
void masterSelected(File selection) {
  if (selection == null) {
    currentCommand = COMMAND_ARRAY[WINDOW_CANCELLED];
  } else if (!selection.getAbsolutePath().toLowerCase().matches("^.*\\.(jpg|gif|png|jpeg)$")) {
    currentCommand = COMMAND_ARRAY[NOT_AN_IMAGE];
    selection = null;
  } else {
    //unlock the sample selection
    setLock(cp5.getController("selectSamples"), false);
    masterImageObject = selection.getAbsolutePath();
    currentCommand = COMMAND_ARRAY[SELECT_SAMPLES];
  }
}


//cut apart each image in the folder
void runDissection() {
  //variable to time this function
  long startTime = System.nanoTime();

  inProgress = true;

  currentCommand = COMMAND_ARRAY[DISSECTING];

  //dissect the master image here, before we loop through the samples
  PImage masterTemp = loadImage(masterImageObject);
  dissectMaster(masterTemp);

  //reset the array so it can run more than once
  //also reset the ArrayList so tiles don't get reused and memory gets freed up
  imageCount = 0;
  tx.clear();

  //set scaling options AFTER the master image has been dissected, and reset resolution
  xIncrement *= scaleFactor;
  yIncrement *= scaleFactor;
  resolution = xIncrement * yIncrement;

  //find directory of sample images NOTE: it doesn't work well if the folder is in "data"
  File dir = new File(samplesPath);
  if (dir.isDirectory()) {
    String[] contents = dir.list();
    printArray(contents);

    int directoryLength = contents.length;
    images = new PImage[directoryLength];
    imageNames = new String[directoryLength];
    for (int i = 0; i < directoryLength; i++) {

      // 1. skip hidden files, if contained in the samples folder
      // 2. also skip non-image format files
      // 3. skip the master file, if contained in the samples folder
      if (contents[i].charAt(0) == '.' ||                                       //1
        !contents[i].toLowerCase().matches("^.*\\.(jpg|gif|png|jpeg)$") ||      //2
        masterImageObject.endsWith(contents[i])) {                              //3
        continue;
      } else {
        File childFile = new File(dir, contents[i]);
        images[imageCount] = loadImage(childFile.getPath());
        imageNames[imageCount] = childFile.getName();

        //check for transparency
        if (contents[i].toLowerCase().matches("^.*\\.(gif|png)$")) {
          //statements to make transparency white
          if (isTransparent(images[imageCount])) {
            images[imageCount] = drawWhite(images[imageCount]);
          }
        }

        println(imageCount, contents[i]);
        currentCommand = imageCount + " " + contents[i];
        dissectImage(images[imageCount]);
      }
      imageCount++;
    }
  }
  println(tx.size());
  currentCommand = COMMAND_ARRAY[NOW_MATCHING];
  //m and tx are the TileObject arrays
  findBestMatch(m, tx);
  dissect = false;
  inProgress = false;
  currentCommand = COMMAND_ARRAY[COMPLETE];

  reconstruct();

  long endTime = System.nanoTime();
  long duration = (endTime - startTime)/1000000;
  println("\n" + "duration " + duration + "\n");
}


//this function takes the brunt of the computations out of the drawing thread
void dissect() {
  if (!isAllFalse(modes)) {
    thread("runDissection");
  } else {
    currentCommand = COMMAND_ARRAY[PICK_MODE];
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
    tx.add(new TileObject(tempX, tempY, tempSource, tempAvg, tempIndex));

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


//this function compares each value in the mValues array to every other value in the bValues array
//to find the closest possible match, then test display the tile image
void findBestMatch(TileObject masterArray[], ArrayList<TileObject> brightness) {
  int bestIndex = 0;
  int valueCounter = 0;
  float tolerance = 0.0005;

  //if using color as the mode, we are dealing with larger ints so we can bring the tolerance up
  if (modes[6]) tolerance = 0.1;

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
  int xDim = m[0].sourceImage.width / xIncrement;
  savedImage = createGraphics(m[0].sourceImage.width, m[0].sourceImage.height);
  //println(m[0].sourceImage.width, m[0].sourceImage.height);
  savedImage.beginDraw();
  savedImage.noStroke();
  savedImage.noFill();
  for (int i = 0; i < m.length; i++) {    
    TileObject newTile = tx.get(newValues[i]);

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
}


String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}