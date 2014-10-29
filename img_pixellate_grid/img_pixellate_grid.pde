import processing.video.*;

Capture cam;

PImage goldman;
PImage webpic;

void setup() {
  size(720, 900);
  //initialize video feed
//  String[] cameras = Capture.list();
//  cam = new Capture(this, cameras[0]);
//  cam.start();
  //uncomment for image conversion
  //goldman = loadImage("g_oldman.jpg");
  webpic = loadImage("webpic.jpg");
}





void draw() {
  background(225);
  //display video feed
//  if (cam.available() == true) {
//    cam.read();
//  }
  //leave commented so you only see the boxes
  //image(cam, 0, 0);
  //image(goldman, 0, 0);
  float boxWidth = 10;
  float boxGap = 5; //the bigger the gap, the smaller the squares and the cooler it looks
  loadPixels();
  for (int x = 0; x < width; x += boxWidth) {
    for (int y = 0; y < height; y += boxWidth) {
      noStroke();
      color c = webpic.get(int(x), int(y));
      /*float g = green(c);
      if (g <= 100) {
        fill(0);
      } else {
        fill(255);
      }*/
      fill(c); //uncomment for color
      rect(x, y, boxWidth-boxGap, boxWidth-boxGap);
    }
  }
}



//save frame function
void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

