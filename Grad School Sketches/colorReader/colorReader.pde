/** Photomosaic generator
 * 
 * TODO: experiment with decrementing the tiling loops, maybe the results will pull from the other side of the image
 * TODO: add internet search functionality, that way users don't have to have a huge folder of images
 */

//----------------libraries
import processing.pdf.*;
import controlP5.*;
import java.util.Calendar;
import java.util.Arrays;
import java.io.FilenameFilter;
import com.drew.imaging.ImageMetadataReader;

//import com.drew.imaging.ImageProcessingException;
//import com.drew.imaging.jpeg.JpegMetadataReader;
//import com.drew.imaging.jpeg.JpegProcessingException;
//import com.drew.imaging.jpeg.JpegSegmentMetadataReader;
//import com.drew.metadata.exif.ExifReader;
//import com.drew.metadata.iptc.IptcReader;
//import java.io.File;

//used for isCmyk()
import java.io.IOException;
import javax.imageio.ImageIO;
import java.awt.color.ColorSpace;
import java.awt.image.*;

ControlP5 cp5;
PFont font, monospace;
ArrayList<TileObject> tx = new ArrayList<TileObject>();
TileObject [] m;
Debug debug = new Debug();
PImage master;

boolean inProgress = false;
boolean selectSamples = false;
boolean selectMaster = false;
boolean approximateWhite = false;
boolean approximateBlack = false;
boolean dissect = false;
boolean debugMode = true;
boolean recursive = false;
boolean setMemLimit = false;
boolean[] modes = new boolean[7]; //r, g, b, h, s, b, c
float bTotal = 0;
float mTotal = 0;
int scaleFactor = 1;
int[] newValues;
int imageCount;
int recursionLimit = 4;
int memLimit = 80;
String masterImageObject;
String samplesPath;

//-------------------block size
int xIncrement = 50;
int yIncrement = 50;
int tileCount;
int resolution;

//--------------------command array strings and constants
final String [] COMMAND = new String[] {
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
  "The file you have selected is not an image. Please select a .jpg, .png, or .gif", 
  "This folder contains no supported image types. Please select a different folder"
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
final static int NO_VALID_FILES = 11;
String currentCommand = COMMAND[SELECT_MASTER];


void setup() {
  //size(1280, 720);
  fullScreen();
  //pixelDensity(displayDensity());
  cp5 = new ControlP5(this);
  font = createFont("UniversLTStd-UltraCn.otf", 24);
  monospace = createFont("Consolas.ttf", 14);
  textFont(font); 
  setupGUI();

  //experimental code here
  File file = new File("/Users/EAM/GitHub/Processing-Sketches/Grad School Sketches/colorReader/colortest/sideways.jpg");
  try {
    Metadata metadata = ImageMetadataReader.readMetadata(file);

    ExifSubIFDDirectory directory = metadata.getFirstDirectoryOfType(ExifSubIFDDirectory.class);
    String colorSpace = directory.getDescription(ExifSubIFDDirectory.TAG_COLOR_SPACE);

    IccDirectory directory2 = metadata.getFirstDirectoryOfType(IccDirectory.class);
    //String colorSpace2 = directory2.getDescription(IccDirectory.TAG_COLOR_SPACE);

    //println(colorSpace/*, colorSpace2*/);
    //printx(metadata);
  } 
  catch (ImageProcessingException e) {
    println(e);
  } 
  catch (IOException e) {
    println(e);
  }
  //println(isCMYK("/Users/EAM/GitHub/Processing-Sketches/Grad School Sketches/colorReader/colortest/cmyktest.jpg"));
  //println(isCMYK("/Users/EAM/GitHub/Processing-Sketches/Grad School Sketches/colorReader/colortest/colortest1.jpg"));
}



//EXPERIMENTAL: function to print image metadata
void printx(Metadata metadata) {
  System.out.println("-------------------------------------");
  for (Directory directory : metadata.getDirectories()) {
    for (Tag tag : directory.getTags()) {
      println(tag);
    }

    if (directory.hasErrors()) {
      for (String error : directory.getErrors()) {
        println("ERROR: " + error);
      }
    }
  }
}


boolean isCMYK(String filename) {
  File f = new File(filename);
  boolean result = false;
  BufferedImage img = null;
  try {
    img = ImageIO.read(f);
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
  noStroke();
  rect(0, 0, width, height);

  //once a master image is chosen, display it every frame
  if (master != null) {
    int workspaceWidth = width-guiWidth;
    float widthDiff = (float)workspaceWidth/master.width;
    float heightDiff = (float)height/master.height;
    imageMode(CENTER);

    //dynamically size the master image
    //TODO: instead of multiple image() calls, set vars inside the if statements and call image() once at the very end
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

  //resolution needs to be set here so that it has a value
  resolution = xIncrement * yIncrement;

  //draw the tiling grid
  // TODO: find a better way to represent this, right now it is only for aspect ratio, it should be used for scale as well
  stroke(255, 0, 0, 80);
  noFill();

  rect(50, 50, xIncrement, yIncrement);

  noStroke();

  //display progress wheel
  if (inProgress) {
    fill(0, 100);
    rect(0, 0, width, height);
    progressWheel((width-guiWidth)/2, height/2);
  }

  //draw the command line
  fill(55);
  rect(0, height-30, width, height-30);
  fill(190);
  textFont(monospace);
  textSize(12);
  text(">  " + currentCommand, 10, height-10);
  noFill();

  popMatrix();

  updateGUI();

  if (debugMode) {
    //these are the only debug values that need to be in draw. everything else only defined once
    debug.tileWidth = xIncrement;
    debug.tileHeight = yIncrement;
  }
}


//progress wheel display function
void progressWheel(int centerX, int centerY) {
  int lineCount = 10;
  strokeWeight(4);
  strokeCap(ROUND);
  pushMatrix();
  translate(centerX, centerY);
  rotate(radians((frameCount * (360/lineCount)) % 360));
  for (int j = 0; j < 360; j += 360/lineCount) {
    stroke(((float)j / 360) * 255);
    float startX = cos(radians(j)) * 10;
    float startY = sin(radians(j)) * 10;
    float endX = cos(radians(j)) * 25;
    float endY = sin(radians(j)) * 25;
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
  boolean result = false;
outerloop:
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      int pixel = img.get(x, y);
      if ((pixel >> 24) == 0x00) {
        result = true;
        break outerloop;
      } else {
        result = false;
      }
    }
  }
  return result;
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


//returns the last saved image from the sketchpath, used for the recursive algorithm
File getLatestFilefromDir(String path) {
  //get the directory
  File dir = new File(path);

  //only load images into the sorting array
  File[] files = dir.listFiles(new FilenameFilter() {
    //must stay public in order to work
    public boolean accept(File dir, String name) {
      return name.toLowerCase().matches("^.*\\.(jpg|gif|png|jpeg)$");
    }
  }
  );

  if (files == null || files.length == 0) {
    // TODO: find all null returns and add console messages for the user
    return null;
  }

  //evaluate which is latest file
  File lastModifiedFile = files[0];
  for (int i = 1; i < files.length; i++) {
    if (lastModifiedFile.lastModified() < files[i].lastModified()) {
      //the ol switcharoo
      lastModifiedFile = files[i];
    }
  }

  //println(lastModifiedFile.getName());
  return lastModifiedFile;
}


//the actual counting function
void tile(PImage theImage, int startX, int startY, int tileSizeX, int tileSizeY) {
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
        //the get method returns only RGB values
        //TODO: this returns the addition of all 3 channels, up to 765.0
        attr = (c1 >> 16 & 0xFF) + (c1 >> 8 & 0xFF) + (c1 & 0xFF);
      }
      bTotal += attr;
      mTotal += attr;
    }
  }
}


//callback function for the samples
void folderSelected(File selection) {
  if (selection == null) {
    currentCommand = COMMAND[WINDOW_CANCELLED];
  } else {
    //unlock the rest of the buttons
    setLock(cp5.getController("xIncrement"), false);
    setLock(cp5.getController("yIncrement"), false);
    setLock(cp5.getController("setMemLimit"), false);
    setLock(cp5.getController("memLimit"), false);
    setLock(cp5.getController("red"), false);
    setLock(cp5.getController("green"), false);
    setLock(cp5.getController("blue"), false);
    setLock(cp5.getController("hue"), false);
    setLock(cp5.getController("saturation"), false);
    setLock(cp5.getController("brightness"), false);
    setLock(cp5.getController("color"), false);
    setLock(cp5.getController("approximateWhite"), false);
    setLock(cp5.getController("approximateBlack"), false);
    setLock(cp5.getController("recursive"), false);
    setLock(cp5.getController("recursionLimit"), false);
    setLock(cp5.getController("dissect"), false);
    samplesPath = selection.getAbsolutePath();
    currentCommand = COMMAND[SET_OPTIONS];
  }
}


//callback function for the master image selection
void masterSelected(File selection) {
  if (selection == null) {
    currentCommand = COMMAND[WINDOW_CANCELLED];
  } else if (!selection.getAbsolutePath().toLowerCase().matches("^.*\\.(jpg|gif|png|jpeg)$")) {
    currentCommand = COMMAND[NOT_AN_IMAGE];
    setLock(cp5.getController("selectSamples"), true);
    selection = null;
  } else {
    //unlock the sample selection
    setLock(cp5.getController("selectSamples"), false);
    masterImageObject = selection.getAbsolutePath();

    //this code only works for images taken with a camera, not images that are created on a computer
    /*
    int orientation = 1;
     int iwidth = 0, iheight = 0;
     try {
     Metadata metadata = ImageMetadataReader.readMetadata(selection);
     Directory directory = metadata.getFirstDirectoryOfType(ExifIFD0Directory.class);
     JpegDirectory jpegDirectory = metadata.getFirstDirectoryOfType(JpegDirectory.class);
     orientation = directory.getInt(ExifIFD0Directory.TAG_ORIENTATION);
     iwidth = jpegDirectory.getImageWidth();
     iheight = jpegDirectory.getImageHeight();
     } 
     catch (MetadataException me) {
     println("Metadata exception: Could not get orientation");
     }
     catch (ImageProcessingException ipe) {
     println("ImageProcessingException exception: Could not get orientation");
     }
     catch (IOException ioe) {
     println("IOException exception: Could not get orientation");
     }
     //catch (InvocationTargetException ite) {}
     
     println("orientation: " + orientation + "\n" + "iwidth: " + iwidth + "\n" + "iheight: " + iheight);
     */

    master = loadImage(masterImageObject);
    //check if the master image contains transparency
    if (isTransparent(master)) {
      println("the master image contained transparency");
      master = drawWhite(master);
    }

    currentCommand = COMMAND[SELECT_SAMPLES];

    if (debugMode) {
      debug.imageWidth = master.width;
      debug.imageHeight = master.height;
    }
  }
}


//cut apart each image in the folder
synchronized void runDissection() {
  //variable to time this function
  long startTime = System.nanoTime();

  inProgress = true;

  currentCommand = COMMAND[DISSECTING];

  //dissect the master image here, before we loop through the samples
  dissectMaster(master);

  //reset the array so it can run more than once
  //also reset the ArrayList so tiles don't get reused and memory gets freed up
  imageCount = 0;
  tx.clear();

  //set scaling options AFTER the master image has been dissected, and reset resolution
  xIncrement *= scaleFactor;
  yIncrement *= scaleFactor;

  //find directory of sample images TODO: it doesn't work well if the folder is in "data"
  File dir = new File(samplesPath);
  if (dir.isDirectory()) {
    //only load images into the sorting array
    File[] files = dir.listFiles(new FilenameFilter() {
      //must stay public in order to work
      public boolean accept(File dir, String name) {
        return name.toLowerCase().matches("^.*\\.(jpg|gif|png|jpeg)$");
      }
    }
    );
    
    int directoryLength = files.length;
    
    String[] contents = new String[directoryLength];
    PImage[] images = new PImage[directoryLength];

    //limit number of images that can be loaded
    if (setMemLimit) directoryLength = memLimit;
    
    for (int i = 0; i < directoryLength; i++) {
      contents[i] = files[i].getName();

      // 1. skip hidden files, if contained in the samples folder
      // 2. skip the master file, if contained in the samples folder
      if (contents[i].charAt(0) == '.' ||                                       //1
        masterImageObject.endsWith(contents[i])) {                              //2
        continue;
      } else {
        File childFile = new File(dir, contents[i]);
        //TODO: we may need a destroy method to flush the cache for the images array after each image is looked at
        images[imageCount] = loadImage(childFile.getPath());

        //handle gifs/pngs and check for transparency
        if (contents[i].toLowerCase().matches("^.*\\.(gif|png)$") && isTransparent(images[imageCount])) {
          images[imageCount] = drawWhite(images[imageCount]);
        }

        currentCommand = imageCount + " " + contents[i];
        dissectImage(images[imageCount]);
      }
      imageCount++;
    }

    //if no file in the directory was an image, tell the user that nothing happened
    if (imageCount == 0) {
      currentCommand = COMMAND[NO_VALID_FILES];
    }
  }
  currentCommand = COMMAND[NOW_MATCHING];

  //m and tx are the TileObject arrays
  findBestMatch(m, tx);
  dissect = false;

  reconstruct();

  inProgress = false;
  currentCommand = COMMAND[COMPLETE];

  long endTime = System.nanoTime();

  if (debugMode) {
    debug.sampledImageCount = imageCount;
    debug.tileCount = tx.size();
    debug.duration = (endTime - startTime) / 1000000;
    debug.logData();
  }
}


//this function takes the brunt of the computations out of the drawing thread
void dissect() {
  //if they were a moron and didnt pick a mode, make them pick one
  if (!isAllFalse(modes)) {
    //TODO: recursion works very well when the functions are not threaded, but obviously threading looks cooler
    runDissection();
    //thread("runDissection");

    //the idea is that with recursion, the dissection will run several times using 
    //the last-dissected image as the master for the new generation
    if (recursive) {
      int recursionIndex = 1;

      while (recursionIndex < recursionLimit) {

        //preserve these values until after the first pass
        //get the last image and set it as the master object
        master = loadImage(getLatestFilefromDir(sketchPath()).getName());
        xIncrement = constrain(xIncrement + (int)random(-20, 20), 2, 100);
        yIncrement = constrain(yIncrement + (int)random(-20, 20), 2, 100);
                
        runDissection();
        //thread("runDissection");

        recursionIndex++;
      }
    }
  } else {
    currentCommand = COMMAND[PICK_MODE];
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

    //count each tile
    tile(image, tempX, tempY, xIncrement, yIncrement);
    bTotal /= resolution;

    //TODO: if you leave the program running and dissect multiple times, the results are different each time. switching modes breaks the program
    //println(bTotal);

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
  float tolerance = 0.005;
  int brokenCount = 0;

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
        brokenCount++;
        break;
      }
    }
    valueCounter++;
  }

  if (debugMode) {
    debug.tolerance = tolerance;
    debug.timesBroken = brokenCount;
  }
}


//write the new image to a file
void reconstruct() {
  //load the 1px images to sub in for near-black and near-white
  PImage black = loadImage("black.png");
  PImage white = loadImage("white.png");

  int xDim = m[0].sourceImage.width / xIncrement;

  //shit works, but PGraphics gets grumpy when combined with pixelDensity(2)
  //hes got the same problem, keep checking back https://github.com/processing/processing/issues/4225

  int newWidth = m[0].sourceImage.width - (m[0].sourceImage.width % xIncrement);
  int newHeight = m[0].sourceImage.height - (m[0].sourceImage.height % yIncrement);

  PGraphics savedImage = createGraphics(newWidth, newHeight);

  //PGraphics savedImage = createGraphics(m[0].sourceImage.width, m[0].sourceImage.height);
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

    //if the tiles is almost black, make it true black to enhance quality
    if (newTile.avgAttribute <= 1.0 && approximateBlack) {
      tileInstance.set(xWalker, yWalker, black);
      println("black");
    }

    //if it's almost white, make it white
    if (newTile.avgAttribute >= 254.0 && approximateWhite) {
      tileInstance.set(xWalker, yWalker, white);
      println("white");
    }

    savedImage.image(tileInstance, xWalker, yWalker);
  }

  savedImage.endDraw();
  savedImage.save(timestamp() + ".png");
}


void keyReleased() {
  if (key == 's' || key == 'S') {
    saveFrame("frame_####.png");
    currentCommand = COMMAND[FRAME_SAVED];
  }
}


String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}