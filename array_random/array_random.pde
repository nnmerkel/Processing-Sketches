import processing.pdf.*;

PImage s;
int total = 12000;
int [] x = new int[total];
int [] y = new int[total];
float bigLimit = 120;
float smallLimit = 40;
float smallLowLimit = 2;
float bigLowLimit = 90;

void setup() {
  size(1200, 1500);
  s = loadImage("dnanew.jpg");
  //beginRecord(PDF, "dnatest1.pdf");
  background(0);
  //overlay();
  highlights();
  points();
  points2();
}

void draw() {
  //saveFrame();
  //endRecord();
  //exit();
}

void overlay() {
  for (int i = 0; i < total; i++) {
    for (int j = 0; j < total; j++) {
      x[i]=int(random(width));
      y[i]=int(random(height));
      color c = s.get(int(x[i]), int(y[i]));
      color cc = s.get(int(x[j]), int(y[j]));
      float redc = red(c);
      float redcc = red(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);

      //target the brightest pixels, but not a white background
      if (redcc >= redc && b > 80 && b < 255 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(1);
        stroke(255);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(3);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }

      //target the exact midtones
      if (redcc >= redc && b > 60 && b < 70 && distance > bigLowLimit && distance < bigLimit) {
        strokeWeight(1);
        stroke(75);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(3);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }

      //target the darkest pixels, but not the black background
      if (redcc >= redc && b > 2 && b < 40 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(1);
        stroke(40);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(3);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }
    }
  }
}

//target the brightest pixels separately so they stand out more
void highlights() {
  for (int i = 0; i < total; i++) {
    for (int j = 0; j < total; j++) {
      x[i]=int(random(width));
      y[i]=int(random(height));
      color c = s.get(int(x[i]), int(y[i]));
      color cc = s.get(int(x[j]), int(y[j]));
      float redc = red(c);
      float redcc = red(cc);
      float b = brightness(c);
      float distance = dist(x[i], y[i], x[j], y[j]);
      if (redcc >= redc && b > 240 && b < 255 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(.5);
        stroke(255);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(2);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }
    }
  }
}

void points() {
  for (int i = 0; i < total; i++) {
    x[i]=int(random(width));
    y[i]=int(random(height));
    color c = s.get(int(x[i]), int(y[i]));
    float b = brightness(c);
    if (b > 180) {
      strokeWeight(2);
      stroke(c);
      point(x[i], y[i]);
    }
  }
}

void points2() {
  for (int i = 0; i < total; i++) {
    x[i]=int(random(width));
    y[i]=int(random(height));
    color c = s.get(int(x[i]), int(y[i]));
    float b = brightness(c);
    if (b > 230) {
      strokeWeight(4);
      stroke(c);
      point(x[i], y[i]);
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

