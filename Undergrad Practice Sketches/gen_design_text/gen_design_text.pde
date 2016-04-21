import processing.pdf.*;

boolean recordPDF = false;
PFont font;
int columnWidth = 50;
int columnHeight = 50;
int customSize = 46;
String message = "Generative Design Visualize, Program, and Create with Processing ";
String alphabet = "abcdefghijklmnopqrstuvwxyz";
String binary = "01";
int index;

void setup() {
  size(800, 800, P2D);//, PDF, "secondTry.pdf");
  font = createFont("Monospaced", customSize, true);
  //SHAPE works with P2D renderer, otherwise comment out this line
  textMode(SHAPE);
  textFont(font);
  textAlign(CENTER, CENTER);
  smooth();
}

void draw() {
  fill(205);
  rect(0, 0, width, height);
  for (int y = 0; y < height; y += columnHeight) {
    for (int x = 0; x < width; x += columnWidth) {
      float randomGen = random(0, 2);
      noFill();
      noStroke();
      //rect(x, y, columnWidth, columnHeight);
      //fill(0);
      if (randomGen <= 1) {
        fill(0);
        textSize(customSize);
        text(message.charAt(index % message.length()), x+columnWidth/2, y+columnHeight/2);
      } else {
        fill(255, 0, 0);
        textSize(customSize);
        text(binary.charAt(int(random(0, binary.length()))), x+columnWidth/2, y+columnHeight/2);
      }
      index++;
    }
    //index = 0;
  }
  //noLoop();
  //println("finished");
  //exit();
}

void keyReleased() {
  if (key =='r' || key =='R') {
    if (recordPDF == false) {
      beginRecord(PDF, "frame-####.pdf");
      println("recording started");
      recordPDF = true;
    }
  } else if (key == 'e' || key =='E') {
    if (recordPDF) {
      println("recording stopped");
      endRecord();
      recordPDF = false;
    }
  }
}

