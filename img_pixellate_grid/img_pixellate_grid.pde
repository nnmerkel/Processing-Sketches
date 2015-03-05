import processing.video.*;

Capture cam;

PImage goldman;

void setup() {
  size(displayWidth, displayHeight);
  //initialize video feed
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  cam.start();
  //uncomment for image conversion
  //goldman = loadImage("g_oldman.jpg");
}





void draw() {
  background(225);
  //display video feed
    if (cam.available() == true) {
      cam.read();
    }
  //leave commented so you only see the boxes
  //image(cam, 0, 0);
  //image(goldman, 0, 0);
  float boxWidth = 20;
  float boxGap = 0; //the bigger the gap, the smaller the squares and the cooler it looks
  loadPixels();
  for (int x = 0; x < width; x += boxWidth) {
    for (int y = 0; y < height; y += boxWidth) {
      noStroke();
      color c = cam.get(int(x), int(y));
      fill(c);
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
