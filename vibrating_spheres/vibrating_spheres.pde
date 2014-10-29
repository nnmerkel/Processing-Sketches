//these variables adjust the spacing of the elements
float a=30;
float b=30;

void setup() {
  size(displayWidth, displayHeight, P2D);
  smooth(8);
  background(0);
  noStroke();
}




void draw() {
  //trying to make an alpha background
  fill(0, 50);
  rect(0, 0, width, height);
  frameRate(60);

  //draw circles and lines
  for (int x=0; x<=width; x+=a) {
    for (int y=0; y<=height; y+=b) {
      pushMatrix();
      translate(x, y);
      tile1();
      tile2();
      tile3();
      popMatrix();
    }
  }
  //draw some transparent circles over it
  for (int i=0; i<height; i+=50) {
    fill(0, 10);
    ellipse(width/2, height/2, i, i);
  }
}

//formula for circles
void tile1() {
  fill(100, 175, random(0, 255), 40);
  ellipse(0, 0, random(0, 50), random(0, 300));
}

//horizontal lines
void tile2() {
  fill(random(0, 255), 50);
  ellipse(0, 0, random(10, 100), noise(10, 30));
}

//vertical lines
void tile3() {
  fill(random(0, 255), 80);
  ellipse(0, 0, noise(10, 30), random(10, 100));
}

//save frame function
void keyPressed() {
  if (key=='s') {
    saveFrame();
    println("frame saved");
  }
}

