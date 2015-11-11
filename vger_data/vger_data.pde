import processing.pdf.*;
import java.util.Calendar;

Table table;

String [] lines;
float [] raTotal, decTotal, velocityWRT;
float [][] data;

int rowTotal, columnTotal;
float raSeconds, raMinutes, decMinutes, decSeconds;

void setup() {
  //attributes
  size(1200, 800);
  pixelDensity(2);
  noStroke();
  
  table = loadTable("vger-data-table.csv", "header");
  
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
}

float xCounter = 0;
int counter = 0;
float puX = 0;
float puValue;
void draw() {
  //pu-238 decay
  puValue = 2 * 470 * pow(2, counter/-87.74);
  
  pushMatrix();
  translate(0, height);
  //frameRate(10);
  
  //data points
  ellipseMode(CENTER);
  fill(200, 100, 0, 140);
  //velocityWRT
  ellipse(xCounter, velocityWRT[counter]*-10, 5, 5);
  
  fill(100, 200, 0, 140);
  //pu-238 decay
  ellipse(puX, puValue*-1, 5, 5);
  
  fill(0, 100, 200, 140);
  ellipse(xCounter, raTotal[counter]*-10, 5, 5);
  
  fill(200, 0, 100, 140);
  ellipse(xCounter, decTotal[counter]*-20, 5, 5);
  
  popMatrix();
  
  xCounter += width/(float)rowTotal;
  puX += width/(float)rowTotal;
  counter++;
  
  if (counter == rowTotal) noLoop();
}

void keyReleased () {
  if (key == 's' || key == 'S') {
    saveFrame(timestamp() + ".png");
    println("frame saved");
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}