Table table;
DataColumns draw;
int rowTotal;
int [] metersList; //distance array
float [] splitTimes, ergTimes; //times arrays converted from the string arrays
float [][] data;
String [] timesList, paceList, dateList;
float scaleFactor = 10;
float elementWidth, polarWidth;
float stepNumber = 50;//speed at which data rectangles grow
//itemCount calculates how many attributes of data each column needs to have. for erg pieces, we need time, pace, distance, and date
int itemCount = 3;

color background = color(205);
color gridLines = color(37, 176, 191, 100);
color mouse = color(40);

void setup() {
  //initialize objects
  table = loadTable("2014_season.csv", "header");
  draw = new DataColumns();
  
  //skecth properties
  size(800, 800);
  pixelDensity(2);
  
  int rowCounter = 0;
  for (TableRow row : table.rows()) {
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
  }

  //make sure all data entries fit on the canvas
  elementWidth = (float)width / rowTotal;
  polarWidth = 360.0 / rowTotal;
}

void draw() {
  //grid attributes
  noStroke();
  noFill();
  background(background);
  stroke(gridLines);
  //grid();
  radialGrid();
  stroke(200, 0, 0);

  //draw the actual singleDataColumns
  //draw.displayCartesian(elementWidth, data);
  draw.displayPolar(polarWidth, data, width/2, height/2);
  //draw.displayBezier(elementWidth, data);
  draw.getAverage(data);
  
  cursor(CROSS);
  //noLoop();
}

void grid () {
  for (int x = 0; x < width; x += elementWidth) {
    line(x, 0, x, height);
  }
  for (int y = 0; y < height; y += elementWidth) {
    line(0, y, width, y);
  }
}

void radialGrid () {
  int concentric = 40;
  float diagonal = dist(0, 0, width, height);
  noFill();
  for (int i = 0; i <= diagonal; i += concentric) {
    ellipse(width/2, height/2, i, i);
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
  if (key == 's' || key =='S') {
    saveFrame("table_####.png");
    println("frame saved");
  }
}

void keyPressed () {
  if (key == '-') {
    scaleFactor += scaleFactor/10;
  }
  if (key == '=') {
    scaleFactor -= scaleFactor/10;
  }
}