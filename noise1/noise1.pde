import processing.pdf.*;
import java.util.Calendar;

float yoff = 0.15;
int functionCount = 255;

boolean record;

void setup() {
  size(displayWidth*2, displayHeight);
}

void draw() {
  if(record) beginRecord(PDF, timestamp() + ".pdf");
  background(255);
  //frameRate(1);
  //looks bad with fill
  noFill();
  for (int i = 0; i < functionCount; i++) {
    float opacity = map(i, 0, 255, 50, functionCount);
    stroke(0, opacity);
    snufflupagus();
  }
  if (record) {
    endRecord();
    println("pdf saved");
  }
}

//create waves
void snufflupagus() {
  beginShape(); 
  float xoff = yoff;
  // do stuff
  for (float x = 0; x <= width; x += 30) {
    // Calculate a y value according to noise, map to 
    float y = map(noise(xoff, yoff), 0, 1, 1100, height-1000);
    vertex(x, y); 
    //this sets how "spiky" each ribbon appears; .25 for desktopBG, .1-.15 for water
    xoff += 0.035;
  }
  // this sets how "tight" each ribbon appears
  yoff += 0.03;
  //vertex(width, height);
  //vertex(0, height);
  endShape();
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

//save frame function
void keyPressed() {
  if (key=='s') {
    saveFrame();
    println("frame saved");
  }
  if (key == 'p' || key == 'P'){
    record = true;
  }
}

