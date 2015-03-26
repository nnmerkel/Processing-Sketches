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
float[] bValues;
float[] mValues;
float[] newValues;

//block size
int xIncrement = 200;
int yIncrement = 200;
int tileCount;
float resolution = xIncrement*yIncrement;
float threshold = 120;

void setup() 
{
  size(800, 800);
  //load master image to be collaged
  //master = loadImage("master.jpg");

  //control GUI
  cp5 = new ControlP5(this);
  Group g2 = cp5.addGroup("g2").setPosition(10, 20).setWidth(200).setBackgroundColor(color(0, 80)).setBackgroundHeight(106).setLabel("Menu");
  //cp5.addSlider("threshold").setPosition(4, 4).setSize(192, 20).setRange(0, 255).setGroup(g2).setValue(120);
  //make sure xIncrement and yIncrement are never set to 0 (a box cannot have 0 width) 
  cp5.addSlider("xIncrement").setPosition(4, 28).setSize(192, 20).setRange(1, 200).setGroup(g2);
  cp5.addSlider("yIncrement").setPosition(4, 52).setSize(192, 20).setRange(1, 200).setGroup(g2);
  //cp5.addToggle("switchStyle").setPosition(4, 76).setSize(16, 16).setCaptionLabel("greater than").setGroup(g2);
}

void draw() 
{
  if (savePDF) beginRecord(PDF, "grid_####.pdf");
  noStroke();
  //image(master, 0, 0);
  for (int x = 0; x < width; x += xIncrement) 
  {
    for (int y = 0; y < height; y += yIncrement) 
    {
      stroke(255, 0, 0, 40);
      noFill();
      rect(x, y, xIncrement, yIncrement);
    }
  }
  if (savePDF) 
  {
    savePDF = false;
    endRecord();
    println("pdf saved");
    exit();
  }
}

//sample the master image
void tile(PImage theImage, int startX, int startY, int tileSizeX, int tileSizeY) 
{
  bTotal = 0;
  mTotal = 0;
  int tileX = tileSizeX + startX;
  int tileY = tileSizeY + startY;
  for (int x = startX; x < tileX; x++) 
  {
    for (int y = startY; y < tileY; y++) 
    {
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

//cut apart each image in the folder
void dissect() 
{
  //find directory of sample images NOTE: it doesn't work well if the folder is in "data"
  File dir = new File(sketchPath, "../samples");
  if (dir.isDirectory()) 
  {
    String[] contents = dir.list();
    println(contents.length + "images detected" + "\n");
    images = new PImage[contents.length]; 
    imageNames = new String[contents.length]; 
    for (int i = 0; i < contents.length; i++) 
    {

      // skip hidden files and folders starting with a dot, load .png files only
      if (contents[i].charAt(0) == '.') continue;
      else
      {
        File childFile = new File(dir, contents[i]);        
        images[imageCount] = loadImage(childFile.getPath()); //PROBLEM LINE <-----------------ArrayIndexOutOfBoundsException: 3
        imageNames[imageCount] = childFile.getName();
        println(imageCount + " " + contents[i] + " " + childFile.getPath());
      } 
      if (contents[i].toLowerCase().equals("master.png") || contents[i].toLowerCase().equals("master.jpg")) 
      {
        dissectMaster(images[imageCount]);
      } else
      {
        dissectImage(images[imageCount]);
        imageCount++;
      }
    }
    //after we take care of the files, reconstruct the image
    PImage sampleTile = images[1].get(200, 200, xIncrement, yIncrement);
    image(sampleTile, 200, 200);
  }
}

//cut apart all the sample images
void dissectImage(PImage image)
{
  println("dissecting", imageNames[imageCount], "now");
  int tileIndex = 0;

  //this will get your cut-and-dry grid count along x and y
  int xDim = image.width / xIncrement;
  int yDim = image.height / yIncrement;

  //this test determines if there is a smaller grid leftover, in which case you still need to compute a bValue for it
  if (image.width % xIncrement != 0) xDim++;
  if (image.height % yIncrement != 0) yDim++;

  //each tile gets its own bValue
  bValues = new float[xDim * yDim];
  println("the array is", xDim, "by", yDim);

  //run the dissection itself
  for (int x = 0; x < image.width; x += xIncrement) 
  {
    for (int y = 0; y < image.height; y += yIncrement) 
    {
      bTotal = 0;

      //count each tile
      tile(image, x, y, xIncrement, yIncrement);
      bTotal = bTotal / resolution;

      //store average brightness for this tile in a master array
      bValues[tileIndex] = bTotal;
      println(tileIndex, "image #" + imageCount, imageNames[imageCount], x, y, bTotal);
      tileIndex++;
    }
  }
}

//run the dissection on the master. identical to dissectImage except the values
//get put into a separate array for comparison later
void dissectMaster(PImage image)
{
  println("dissecting the master now");
  int tileIndex = 0;

  //this will get your cut-and-dry grid count along x and y
  int xDim = image.width / xIncrement;
  int yDim = image.height / yIncrement;
  
  //tileCount will be used later to reconstruct the collage, maybe?
  tileCount = xDim * yDim;

  //this test determines if there is a smaller grid leftover, in which case you still need to compute an mValue for it
  if (image.width % xIncrement != 0) xDim++;
  if (image.height % yIncrement != 0) yDim++;

  //each tile gets its own mValue
  mValues = new float[xDim * yDim];

  //run dissection on the master
  for (int x = 0; x < image.width; x += xIncrement) 
  {
    for (int y = 0; y < image.height; y += yIncrement) 
    {
      mTotal = 0;

      //count each tile
      tile(image, x, y, xIncrement, yIncrement);
      mTotal = mTotal / resolution;

      //store average brightness for this tile in a master array
      mValues[tileIndex] = mTotal;
      println(tileIndex, "master" + imageCount, imageNames[imageCount], x, y, mTotal);
      tileIndex++;
    }
  }
  printArray(mValues);
  findBestMatch(mValues, bValues, tileCount, image);
}

//this function compares each value in the mValues array to every other value in the bValues array
//to find the closest possible match, then test display the tile image
void findBestMatch(float masterArray[], float brightnessArray[], int tileCount, PImage image)
{
  int bestIndex = 0;
  int valueCounter = 0;
  for (int i = 0; i < masterArray.length; i++)
  {
    float bestDiff = abs(masterArray[i] - brightnessArray[0]);
    for (int j = 0; j < brightnessArray.length; j++)
    {
      float diff = abs(masterArray[i] - brightnessArray[j]);
      if (diff <= bestDiff) //check back here on the less than/equal to tiebreaker
      {
        //here’s a potential match; don’t stop now as there could be a better match later
        bestIndex = j;
        bestDiff = diff;
      }
    }

    //make a new array here to store each bestIndex, then extract those values in a different function and display them
    newValues = new float[masterArray.length];
    newValues[valueCounter] = bestIndex;
    valueCounter++;
  }
  println(bestIndex, mValues[bestIndex], bValues[bestIndex]);
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
}

