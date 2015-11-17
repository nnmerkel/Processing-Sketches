import processing.pdf.*;
import java.util.Calendar;

Table table;
PFont font;

String [] lines;
float [] raTotal, decTotal, velocityWRT;
float [][] data;

boolean record = false;
int rowTotal, columnTotal;
int d = 3;
float raSeconds, raMinutes, decMinutes, decSeconds;

void setup() {
  //attributes
  size(1200, 800);
  pixelDensity(2);
  noStroke();

  table = loadTable("vger-data-table.csv", "header");

  font = createFont("Silom", 16);
  textFont(font);

  rowTotal = table.getRowCount();
  columnTotal = 3;

  data = new float[columnTotal][rowTotal];
  velocityWRT = new float[rowTotal];
  raTotal = new float[rowTotal];
  decTotal = new float[rowTotal];

  //load data into arrays
  for (int i = 0; i < rowTotal; i++) {
    velocityWRT[i] = table.getRow(i).getFloat("velocity wrt sun");
    raSeconds = table.getRow(i).getFloat("ra ss");
    raMinutes = table.getRow(i).getFloat("ra mm");
    raTotal[i] = table.getRow(i).getFloat("ra hh") + raMinutes/60 + raSeconds/60;

    decMinutes = table.getRow(i).getFloat("dec mm");
    decSeconds = table.getRow(i).getFloat("dec ss");
    decTotal[i] = table.getRow(i).getFloat("dec dd") + decMinutes/60 + decSeconds/60;
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
  if (record) {
    beginRecord(PDF, timestamp() + ".pdf");
    println("recording...");
  }
  //pu-238 decay
  puValue = 2 * 470 * pow(2, counter/-87.74);
  puValue = round(puValue * 1000f) / 1000f;

  pushMatrix();
  translate(0, height);
  //frameRate(10);

  //data points
  ellipseMode(CENTER);
  fill(200, 100, 0, 140);
  //velocityWRT
  ellipse(xCounter, velocityWRT[counter]*-10, d, d);
  if (counter < rowTotal-1) {
    stroke(200, 100, 0, 140);
    line(xCounter, velocityWRT[counter]*-10, xCounter+width/(float)rowTotal, velocityWRT[counter+1]*-10);
    noStroke();
  }

  //pu-238 decay
  if (counter % 40 == 0) {
    noFill();
    stroke(50);
    ellipse(puX, puValue*-1, d, d);
    line(puX, -2, puX, -7);
    line(2, puValue*-1, 7, puValue*-1);
    noStroke();
    plutonium = String.valueOf(puValue);
    fill(50);
    text(plutonium, puX+5, puValue*-1);
  } else {
    fill(100, 200, 0, 140);
  }
  ellipse(puX, puValue*-1, d, d);
  
  //right ascension
  fill(0, 100, 200, 140);
  ellipse(xCounter, raTotal[counter]*-10, d, d);
  if (counter < rowTotal-1) {
    stroke(0, 100, 200, 140);
    line(xCounter, raTotal[counter]*-10, xCounter+width/(float)rowTotal, raTotal[counter+1]*-10);
    noStroke();
  }
  
  //declination
  fill(200, 0, 100, 140);
  ellipse(xCounter, decTotal[counter]*-20, d, d);
  if (counter < rowTotal-1) {
    stroke(200, 0, 100, 140);
    line(xCounter, decTotal[counter]*-20, xCounter+width/(float)rowTotal, decTotal[counter+1]*-20);
    noStroke();
  }

  popMatrix();

  xCounter += width/(float)rowTotal;
  puX += width/(float)rowTotal;
  counter++;
  
  if (counter == rowTotal) {
    endRecord();
    record = false;
    noLoop();
    println("pdf saved");
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