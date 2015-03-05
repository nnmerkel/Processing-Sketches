float yoff = 0.1;
int functionCount = 200;

void setup() {
  size(displayWidth, displayHeight);
}

void draw() {
  background(0);
  //frameRate(1);
  //looks bad with fill
  noFill();
  for (int i = 0; i < functionCount; i++) {
    float opacity = map(i, 0, functionCount, (255-functionCount)/1.5, functionCount/1.5);
    stroke(255, opacity);
    snufflupagus();
  }
}

//create waves
void snufflupagus() {
  beginShape(); 
  float xoff = yoff;
  // do stuff
  for (float x = 0; x <= width; x += 30) {
    // Calculate a y value according to noise, map to 
    float y = map(noise(xoff, yoff), 0, 1, 100, height-400);
    vertex(x, y); 
    //this sets how "spiky" each ribbon appears; .25 for desktopBG, .1-.15 for water
    xoff += 0.2;
  }
  // this sets how "tight" each ribbon appears
  yoff += 0.03;
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}

//save frame function
void keyPressed() {
  if (key=='s') {
    saveFrame();
    println("frame saved");
  }
}

