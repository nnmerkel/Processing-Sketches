import processing.pdf.*;

void setup() {
  //do not use p2d to render; it makes the bezier curves look steppy
  size(3000, 1000); //PDF, "viruscover3.pdf");
  smooth(8);
  background(0);
}

void draw() {
  noStroke();
  fill(0, 30);
  rect(0, 0, width, height);
  noiseCurve();
  noiseCurve();
  curve();
  curve();
  curve();
  
  //noLoop();
  //println("finished");
  //exit();
  
}

//draw a curved line end to end
void curve() {
  float randa = random(0, width);
  float randb = random(0, width);
  float diam = randb-randa;
  noFill();
  stroke(255);
  strokeWeight(1);
  bezier(randa, 0, randa, height/2, randb, height/2, randb, height);
  //draw solid circles at the endpoints
  noStroke();
  fill(255);
  ellipse(randa, 0, 6, 6);
  ellipse(randb, height, 6, 6);
  //draw transparent circles, diameter based on length of curve
  fill(255, 70);
  ellipse(randa, 0, diam/10, diam/10);
  ellipse(randb, height, diam/10, diam/10);
}

//curve using noise rather than random
float xoff = 0.0;
float x2off = 0.0;

void noiseCurve() {
  float randa = noise(xoff) * width;
  float randb = noise(x2off) * width;
  float diam = randb-randa;
  xoff = xoff + .1;
  x2off = x2off + .25;
  noFill();
  stroke(255);
  strokeWeight(1);
  bezier(randa, 0, randa, height/2, randb, height/2, randb, height);
  //draw solid circles at the endpoints
  noStroke();
  fill(255);
  ellipse(randa, 0, 6, 6);
  ellipse(randb, height, 6, 6);
  //draw transparent circles, diameter based on length of curve
  fill(255, 70);
  ellipse(randa, 0, diam/10, diam/10);
  ellipse(randb, height, diam/10, diam/10);
}

void keyPressed() {
  if (key=='s') {
    saveFrame();
    println("frame saved");
  }
}

