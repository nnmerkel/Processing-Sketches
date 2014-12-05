import processing.pdf.*;

PImage s;
int total = 8000;
int [] x = new int[total];
int [] y = new int[total];
float bigLimit = 120;
float smallLimit = 40;
float smallLowLimit = 2;
float bigLowLimit = 90;

void setup() {
  size(884, 1024);//, PDF, "n1.pdf");
  s = loadImage("n2.jpg");
  background(0);
  //overlayWide();
  overlay();
}

void draw() {
  //saveFrame();
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
      if (redcc >= redc && b > 100 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(1);
        stroke(255);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(3);
        point(x[i], y[i]);
        point(x[j], y[j]);
      }
    }
  }
}

void overlayWide() {
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
      if (redcc >= redc && b > 100 && b < 150 && distance > smallLowLimit && distance < bigLimit) {
        strokeWeight(1);
        stroke(200);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(3);
        //point(x[i], y[i]);
        //point(x[j], y[j]);
      }
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

