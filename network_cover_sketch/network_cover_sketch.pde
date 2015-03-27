import processing.pdf.*;

boolean record = false;

void setup() {
  size(displayWidth*2, displayHeight);//, PDF, "networkcover15.pdf");
  smooth(8);
  background(0);
  noStroke();
}


void draw() {
  if (record) beginRecord(PDF, "networkndssl_####.pdf");
  fill(0);
  noStroke();
  rect(0, 0, width, height);
  frameRate(1);
  network1();
  network1();
  network1();
  network1();
  network1();
  network1();
  network1();
  network1();
  if (record) {
    println("pdf saved");
    endRecord();
    record = false;
    //exit();
  }
}



//circles and lines
void network1() {
  //each of these variables must be its own set of random() generation
  //otherwise the circles will all have the same radius and position
  //variables for the first circle
  float radx1 = random(20, 80);
  float xp1 = random(100, (width-60));
  float yp1 = random(100, (height-60));
  //variables for the second circle
  float radx2 = random(20, 80);
  float xp2 = random(100, (width-60));
  float yp2 = random(100, (height-60));
  //variables for the third circle
  float radx3 = random(20, 80);
  float xp3 = random(100, (width-60));
  float yp3 = random(100, (height-60));
  //variables for the fourth circle
  float radx4 = random(20, 80);
  float xp4 = random(100, (width-60));
  float yp4 = random(100, (height-60));
  //variables for the fifth circle
  float radx5 = random(20, 80);
  float xp5 = random(100, (width-60));
  float yp5 = random(100, (height-60));
  //variables for the sixth circle
  float radx6 = random(20, 80);
  float xp6 = random(100, (width-60));
  float yp6 = random(100, (height-60));
  //variables for the seventh circle
  float radx7 = random(20, 80);
  float xp7 = random(100, (width-60));
  float yp7 = random(100, (height-60));

  stroke(255);
  //first line connect 1 and 2
  strokeWeight(1);
  line(xp1, yp1, xp2, yp2);
  line(xp1, yp1, xp3, yp3);
  line(xp1, yp1, xp4, yp4);
  line(xp1, yp1, xp5, yp5);
  line(xp1, yp1, xp6, yp6);
  //connect 2 to 3
  //line(xp2, yp2, xp3, yp3);
  //line(xp4, yp4, xp3, yp3);
  //connect 4 to 2
  //line(xp2, yp2, xp4, yp4);
  //connect 5 to 2
  //line(xp2, yp2, xp5, yp5);
  //connect 6 to 2
  line(xp2, yp2, xp6, yp6);
  //connect 7 to 2
  //line(xp2, yp2, xp7, yp7);
  //connect 5 to 7
  line(xp5, yp5, xp7, yp7);
  //connect 7 to 3
  //line(xp3, yp3, xp7, yp7);

  fill(255);
  noStroke();

  //first circle
  ellipse(xp1, yp1, radx1, radx1);
  fill(0);
  ellipse(xp1, yp1, (radx1-6), (radx1-6));
  fill(255);
  ellipse(xp1, yp1, (radx1-50), (radx1-50));

  //second circle
  fill(255);
  ellipse(xp2, yp2, radx2, radx2);
  fill(0);
  ellipse(xp2, yp2, (radx2-6), (radx2-6));
  fill(255);
  ellipse(xp2, yp2, (radx2-50), (radx2-50));

  //third circle
  fill(255);
  ellipse(xp3, yp3, radx3, radx3);
  fill(0);
  ellipse(xp3, yp3, (radx3-6), (radx3-6));
  fill(255);
  ellipse(xp3, yp3, (radx3-50), (radx3-50));

  //fourth circle
  fill(255);
  ellipse(xp4, yp4, radx4, radx4);
  fill(0);
  ellipse(xp4, yp4, (radx4-6), (radx4-6));
  fill(255);
  ellipse(xp4, yp4, (radx4-50), (radx4-50));

  //fifth circle
  fill(255);
  ellipse(xp5, yp5, radx5, radx5);
  fill(0);
  ellipse(xp5, yp5, (radx5-6), (radx5-6));
  fill(255);
  ellipse(xp5, yp5, (radx5-50), (radx5-50));

  //sixth circle
  fill(255);
  ellipse(xp6, yp6, radx6, radx6);
  fill(0);
  ellipse(xp6, yp6, (radx6-6), (radx6-6));
  fill(255);
  ellipse(xp6, yp6, (radx6-50), (radx6-50));

  //seventh circle
  fill(255);
  ellipse(xp7, yp7, radx7, radx7);
  fill(0);
  ellipse(xp7, yp7, (radx7-6), (radx7-6));
  fill(255);
  ellipse(xp7, yp7, (radx7-50), (radx7-50));
}

//save frame function
void keyPressed() {
  if (key=='s') {
    saveFrame();
    println("frame saved");
  }
  if (key == 'p' || key == 'P') {
    record = true;
  }
}

