import processing.pdf.*;
import java.util.Calendar;

Table table;
PFont font;

String [] month;
String stringYear;
float [] raTotal, decTotal, velocityWRT;
float [][] data;
int year;

boolean record = false;
int rowTotal, columnTotal;
int d = 3;
float raSeconds, raMinutes, decMinutes, decSeconds;

void setup() {
  //attributes
  size(1200, 800);
  //textMode(SHAPE);
  //beginRecord(PDF, timestamp() + ".pdf");
  //println("recording...");
  pixelDensity(2);
  strokeWeight(d);

  table = loadTable("vger-data-table.csv", "header");

  font = createFont("UniversLTStd-UltraCn.otf", 14);
  textFont(font);

  rowTotal = table.getRowCount();
  columnTotal = 3;

  data = new float[columnTotal][rowTotal];
  velocityWRT = new float[rowTotal];
  raTotal = new float[rowTotal];
  decTotal = new float[rowTotal];
  month = new String[rowTotal];

  //load data into arrays
  for (int i = 0; i < rowTotal; i++) {
    String joinedDate = table.getRow(i).getString("month") + " " + table.getRow(i).getInt("year");
    month[i] = joinedDate;
    
    velocityWRT[i] = table.getRow(i).getFloat("velocity wrt sun");
    
    raSeconds = table.getRow(i).getFloat("ra ss");
    raMinutes = table.getRow(i).getFloat("ra mm");
    raTotal[i] = table.getRow(i).getFloat("ra hh") + raMinutes/60 + raSeconds/3600;

    decMinutes = table.getRow(i).getFloat("dec mm");
    decSeconds = table.getRow(i).getFloat("dec ss");
    decTotal[i] = table.getRow(i).getFloat("dec dd") + decMinutes/60 + decSeconds/3600;
  }

  //font listing
  //String[] fontList = PFont.list();
  //printArray(fontList);
}

float xCounter = 0;
int counter = 0;
float puX = 0;
float puValue;
String plutonium;
void draw() {
  //pu-238 decay
  puValue = 2 * 470 * pow(2, counter/-87.74);
  puValue = round(puValue * 1000f) / 1000f;

  pushMatrix();
  translate(0, height);
  //frameRate(10);

  //data points
  strokeWeight(d);
  stroke(200, 100, 0, 140);
  //velocityWRT
  point(xCounter, velocityWRT[counter]*-10);
  if (counter < rowTotal-1) {
    strokeWeight(1);
    stroke(200, 100, 0, 140);
    line(xCounter, velocityWRT[counter]*-10, xCounter+width/(float)rowTotal, velocityWRT[counter+1]*-10);
    noStroke();
  }

  //pu-238 decay
  if (counter % 40 == 0) {
    noFill();
    strokeWeight(d);
    stroke(50);
    point(puX, puValue*-1);
    strokeWeight(1);
    line(puX, -2, puX, -7);
    line(2, puValue*-1, 7, puValue*-1);
    noStroke();
    plutonium = String.valueOf(puValue/2);
    fill(150);
    text(plutonium, puX+5, puValue*-1);
  } else {
    strokeWeight(d);
    stroke(100, 200, 0, 140);
  }
  point(puX, puValue*-1);

  //right ascension
  stroke(0, 100, 200, 140);
  strokeWeight(d);
  point(xCounter, raTotal[counter]*-10);
  if (counter < rowTotal-1) {
    strokeWeight(1);
    stroke(0, 100, 200, 140);
    line(xCounter, raTotal[counter]*-10, xCounter+width/(float)rowTotal, raTotal[counter+1]*-10);
    noStroke();
  }

  //declination
  stroke(200, 0, 100, 140);
  strokeWeight(d);
  point(xCounter, decTotal[counter]*-20);
  if (counter < rowTotal-1) {
    strokeWeight(1);
    stroke(200, 0, 100, 140);
    line(xCounter, decTotal[counter]*-20, xCounter+width/(float)rowTotal, decTotal[counter+1]*-20);
    noStroke();
  }
  
  //dates
  if (counter % 24 == 0) {
    textSize(12);
    fill(150);
    text(month[counter], xCounter, -10);
    noFill();
  }

  popMatrix();

  xCounter += width/(float)rowTotal;
  puX += width/(float)rowTotal;
  counter++;

  if (counter == rowTotal) {
    //endRecord();
    //record = false;
    noLoop();
    //println("pdf saved");
  }
}

void keyReleased () {
  if (key == 's' || key == 'S') {
    saveFrame(timestamp() + ".png");
    println("frame saved");
  }
  if (key == 'p' || key == 'P') {
    record = true;
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}