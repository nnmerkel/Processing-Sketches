import processing.pdf.*;

float divisor = 8;
float diam2 = 8;

void setup() {
  //do not use p2d to render; it makes the bezier curves look steppy
  size(1100, 1700);//, PDF, "virusexp1.pdf");
  smooth(8);
  background(255);
}

void draw() {
  noStroke();
  fill(255, 30);
  rect(0, 0, width, height);
  noiseCurve();
  noiseCurve();
  noiseCurve();
  curve();
  curve();
}

//draw a curved line end to end
void curve() {
  float randa = random(0, width);
  float randb = random(0, width);
  float diam = randb-randa;
  noFill();
  stroke(29, 99, 175, 150);
  strokeWeight(1);
  bezier(randa, 0, randa, height/3, randb, height/1.5, randb, height);
  //draw solid circles at the endpoints
  noStroke();
  fill(29, 99, 175);
  ellipse(randa, 0, diam2, diam2);
  ellipse(randb, height, diam2, diam2);
  //draw transparent circles, diameter based on length of curve
  fill(29, 99, 175, 70);
  ellipse(randa, 0, diam/divisor, diam/divisor);
  ellipse(randb, height, diam/divisor, diam/divisor);
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
  stroke(29, 99, 175, 150);
  strokeWeight(1);
  bezier(randa, 0, randa, height/3, randb, height/1.5, randb, height);
  fill(29, 99, 175, 150);
  ellipse(randa, height/3, diam2, diam2);
  ellipse(randb, height/1.5, diam2, diam2);
  //draw solid circles at the endpoints
  noStroke();
  fill(29, 99, 175);
  ellipse(randa, 0, diam2, diam2);
  ellipse(randb, height, diam2, diam2);
  //draw transparent circles, diameter based on length of curve
  fill(29, 99, 175, 70);
  ellipse(randa, 0, diam/divisor, diam/divisor);
  ellipse(randb, height, diam/divisor, diam/divisor);
}

void keyPressed() {
  if (key=='s') {
    saveFrame();
    println("frame saved");
  }
  if (key == 'p'|| key == 'P') {
    beginRecord(PDF, "virusexp_####.pdf");
  }
  if (key == 'e'|| key == 'E') {
    endRecord();
    exit();
  }
}

