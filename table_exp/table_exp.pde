/**
 
 Keys:    a              show/hide axes
 s              save PNG frame
 p              save PDF
 - / _          zoom out
 + / =          zoom in
 */

//libraries
import controlP5.*;
import processing.pdf.*;
import java.util.Calendar;

//classes/objects
Table table;
ControlP5 cp5;
DataColumns draw;

//Cp5 variables
Slider[] sliders;
Range[] ranges;
Toggle[] toggles;
RadioButton radio;

//global variables
boolean record, axes, usePolar, useCartesian, useBezier, useRadialGrid, useGrid, average, normalize;
int rowTotal;
int [] metersList; //straight meters array
float [] splitTimes, ergTimes; //times arrays converted from the string arrays
float [][] data, testArray;
String [] timesList, paceList, dateList; //original list arrays from .csv
float elementWidth, polarWidth, logK;
float scaleFactor = 30;
float stepNumber = 50; //speed at which data rectangles grow
//itemCount calculates how many attributes of data each column needs to have. for erg pieces, we need time, pace, and distance
int itemCount = 3;

//colors
color background = color(205);
color gridLines = color(37, 176, 191);
color mouse = color(40);
float fillHue, fillSaturation, fillBrightness, differential, strokeHue, strokeBrightness, strokeSaturation;

void setup() {
  //initialize objects
  table = loadTable("2014_season.csv", "header");
  draw = new DataColumns();
  cp5 = new ControlP5(this);

  //skecth properties
  size(1200, 800);
  pixelDensity(2);

  int rowCounter = 0;
  for (int t = 0; t < table.getRowCount(); t++) {
    rowCounter++;
  }
  rowTotal = rowCounter;

  metersList = new int[rowTotal];
  splitTimes = new float[rowTotal];
  ergTimes = new float[rowTotal];

  timesList = new String[rowTotal];
  paceList = new String[rowTotal];
  dateList = new String[rowTotal];

  //double array that contains all other arrays
  data = new float[rowTotal][itemCount];
  testArray = new float[rowTotal][itemCount];

  for (int i = 0; i < rowTotal; i++) {
    //create arrays of each column of data
    metersList[i] = table.getRow(i).getInt("Meters");
    timesList[i] = table.getRow(i).getString("Total Time");
    paceList[i] = table.getRow(i).getString("Pace");
    dateList[i] = table.getRow(i).getString("Date");

    //convert the erg times to seconds
    String entry = timesList[i];
    String parts[] = splitTokens(entry, ":.");
    int minutes = Integer.parseInt(parts[0]);
    int seconds = Integer.parseInt(parts[1]);
    int fractions = Integer.parseInt(parts[2]);
    ergTimes[i] = (minutes * 60) + seconds + (fractions / 10);

    //convert the splits to seconds
    String paceEntry = paceList[i];
    String paceParts[] = splitTokens(paceEntry, ":.");
    int paceMinutes = Integer.parseInt(paceParts[0]);
    int paceSeconds = Integer.parseInt(paceParts[1]);
    int paceFractions = Integer.parseInt(paceParts[2]);
    splitTimes[i] = (paceMinutes * 60) + paceSeconds + (paceFractions / 10);

    //load items into the master array
    data[i][0] = metersList[i];
    data[i][1] = ergTimes[i];
    data[i][2] = splitTimes[i];

    testArray[i][0] = 100;
    testArray[i][1] = 100;
    testArray[i][2] = 100;
  }

  //make sure all data entries fit on the canvas
  elementWidth = (float)width / rowTotal;
  polarWidth = 360.0 / rowTotal;
  //println(polarWidth, radians(polarWidth));
  
  //default value for scaling
  logK = 2;
  setupGUI();
}

void draw() {
  if (record) {
    beginRecord(PDF, timestamp() + ".pdf");
  }
  noStroke();
  noFill();
  strokeCap(SQUARE);
  colorMode(HSB, 360, 100, 100);
  background(background);
  if (axes) {
    pushMatrix();
    translate(elementWidth, elementWidth);
    axes();
  }
  
  //grid attributes & methods
  if (useGrid) {
    grid();
  }
  if (useRadialGrid) {
    radialGrid();
  }
  
  strokeCap(SQUARE);
  stroke(gridLines, 200);
  //display methods
  if (useCartesian) {
    draw.displayCartesian(elementWidth, data, scaleFactor);
  }
  if (usePolar) {
    draw.displayPolar(polarWidth, data, width/2, height/2, scaleFactor);
  }
  //draw.displayPolarSingleItem(polarWidth, data, width/2, height/2, 0, scaleFactor);
  
  noFill();
  if (useBezier) {
    draw.displayBezier(elementWidth, data, scaleFactor);
  }
  
  if (useCartesian && average) {
    stroke(255, 0, 0);
    draw.getAverage(data);
  }
  
  //draw.getAverage(data);

  cursor(CROSS);
  //noLoop();
  if (record) {
    endRecord();
    record = false;
    println("pdf saved");
  }
  if (axes) {
    popMatrix();
  }
  //noLoop();
}

void grid () {
  int counter = 0;
  for (int x = 0; x < width; x += elementWidth) {
    if (counter != 0 && counter % 10 == 0) stroke(gridLines, 150);
    else stroke(gridLines, 50);
    line(x, 0, x, height);
    counter++;
  }
  for (int y = 0; y < height; y += elementWidth) {
    if (counter != 0 && counter % 10 == 0) stroke(gridLines, 150);
    else stroke(gridLines, 50);
    line(0, y, width, y);
    counter++;
  }
}

void radialGrid () {
  int concentric = 40;
  int counter = 0;
  float diagonal = dist(0, 0, width, height);
  noFill();
  for (int i = 0; i <= diagonal; i += concentric) {
    if (counter != 0 && counter % 10 == 0) stroke(gridLines, 150);
    else stroke(gridLines, 50);
    ellipse(width/2, height/2, i, i);
    counter++;
  }
  for (int j = 0; j < 360; j += polarWidth) {
    pushMatrix();
    translate(width/2, height/2);
    line(0, 0, cos(radians(j))*diagonal/2, sin(radians(j))*diagonal/2);
    popMatrix();
  }
  stroke(80);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
}

void axes() {
  stroke(20, 200);
  strokeWeight(2);
  line(-elementWidth, -elementWidth, width, -elementWidth);
  line(-elementWidth, -elementWidth, -elementWidth, height);
  strokeWeight(1);
}

float heightIncrement = 0;
void grow(float startX, float endValue) {
  //println(endValue);
  if (heightIncrement < endValue) {
    heightIncrement += (endValue/stepNumber);
  } else {
    heightIncrement += 0;
  }
  rect(startX, 0, elementWidth, heightIncrement);
}

void keyReleased () {
  if (key == 's' || key == 'S') {
    saveFrame(timestamp() + ".png");
    println("frame saved");
  }
  if (key == 'p' || key == 'P') {
    record = true;
  }
  if (key == 'a' || key == 'A') {
    axes = !axes;
  }
}

void keyPressed () {
  if (key == '-' || key == '_') {
    scaleFactor -= scaleFactor/10;
  }
  if (key == '=' || key == '+') {
    scaleFactor += scaleFactor/10;
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}