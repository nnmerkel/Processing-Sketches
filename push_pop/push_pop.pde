float rot = 0;

void setup() {
  size(displayWidth, displayHeight);
  smooth(8);
}


void draw() {
  background(0);
  rot = mouseX;
  /*pushMatrix();
  translate(displayWidth/2, displayHeight/2);
  rotate(radians(rot));
  rectMode(CENTER);
  rect(0, 0, 100, 100);
  popMatrix();*/

  for (int i=0; i<height; i++) {
    pushMatrix();
  translate(displayWidth/2, displayHeight/2);
  rotate(radians(rot+=2*i));
  rectMode(CENTER);
  noStroke();
  fill(i, 0, 100);
  rect(i+mouseY, i+mouseX, 100, 100);
  popMatrix();
  }
}


void keyPressed() {
  if (key=='s') {
    saveFrame("line_sketch_#####.tif");
    println("frame saved");
  }
}

