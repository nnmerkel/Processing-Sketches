float yoff = 0.0;

void setup() {
  size(displayWidth, displayHeight, P2D);
}

void draw() {
  background(0);
  //trying to slow it down so i can see it better...
  frameRate(5);
  //looks bad with fill
  noFill();
  bigBird();
  bigBird();
}

//create waves
void snufflupagus() {
  beginShape(); 
  float xoff = yoff;
  // do stuff
  for (float x = 0; x <= width; x += 20) {
    // Calculate a y value according to noise, map to 
    float y = map(noise(xoff, yoff), 0, 1, 300, 700);
    vertex(x, y); 
    //increment x noise
    xoff += 0.2;
  }
  // increment y noise
  yoff += 0.03;
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}

//create nested functions so i can tile it?
void bigBird() {
  for (int x = 0; x <= width; x+=600) {
    for (int y = 0; y <= height; y+=100) {
      stroke(255, x);
      snufflupagus();
    }
  }
}

//save frame function
void keyPressed() {
  if (key=='s') {
    saveFrame();
    println("frame saved");
  }
}

