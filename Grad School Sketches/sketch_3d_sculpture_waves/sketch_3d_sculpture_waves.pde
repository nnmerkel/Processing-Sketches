float total = 300;
float xoff = 0.0;
float yoff = 0.0;
float radius;

boolean record = false;

void setup() {
  size(640, 360);
  radius = 200;
}

void draw() {
  if (record) beginRecord("nervoussystem.obj.OBJExport", "shape_####.obj");

  fill(205);
  noStroke();
  rect(0, 0, width, height);
  noFill();
  pushMatrix();
  translate(width/2, height/2);
  meep(noise(xoff)*radius);
  xoff += 0.0001;
  popMatrix();

  if (record) {
    endRecord();
    record = false;
  }
}


void meep(float xoff) {
  stroke(0);
  strokeWeight(1);
  for (float i = 0.0; i < 360.0; i+=360.0/total) {
    pushMatrix();
    rotate(radians(i));

    point(xoff, 0);

    popMatrix();
  }
}


//create a circle of points
void wave() {
  stroke(0);
  strokeWeight(3);
  for (int i = 0; i < 360; i+=360/total) {
    point(cos(radians(i)) * radius, sin(radians(i)) * radius);
    println(cos(radians(i)) * radius, sin(radians(i)) * radius);
  }
}


void wave2() {
  stroke(0);
  strokeWeight(1);

  beginShape();

  //pushMatrix();
  for (float i = 0.0; i < 360.0; i+=360.0/total) {
    //rotate(radians(i) * 50);
    //println(i);

    float x = noise(xoff)*radius;
    float y = noise(yoff)*radius;
    xoff += 0.0001;
    yoff += 0.017;

    strokeWeight(3);
    vertex(cos(radians(i))*x, sin(radians(i))*y);
    strokeWeight(1);
  }
  //popMatrix();

  endShape();
}


void wave3() {
  stroke(0);
  strokeWeight(1);

  //beginShape();

  //pushMatrix();
  for (float i = 0.0; i < 360.0; i+=360.0/total) {
    pushMatrix();
    rotate(radians(i));
    //println(i);

    float x = noise(xoff)*radius;

    point(x, 0);

    xoff += 0.0001;
    popMatrix();
  }
  //popMatrix();

  //endShape();
}