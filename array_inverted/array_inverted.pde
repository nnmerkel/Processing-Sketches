import processing.pdf.*;

PImage s;
int total = 8000;
int level = 0;
int [] x = new int[total];
int [] y = new int[total];

void setup() {
  size(1366, 768);//, PDF, "e.pdf");
  s = loadImage("dna.jpg");
  background(255);
  overlayLightMids();
  overlayMids();
  overlayDarkMidsBig();
  overlayDarkMids();
  overlayDarks();
  overlayBrights();
}

void draw() {
  //saveFrame();
  //exit();
}

void overlayBrights() {
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
      stroke(255);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b > 200 && distance > 4 && distance < 40) {
        line(x[i], y[i], x[j], y[j]);
      }
    }
  }
}

void overlayMids() {
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
      stroke(150);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b > 100 && b < 150 && distance > 2 && distance < 40) {
        line(x[i], y[i], x[j], y[j]);
      }
    }
  }
}

void overlayLightMids() {
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
      stroke(210);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b > 150 && b < 200 && distance > 4 && distance < 30) {
        line(x[i], y[i], x[j], y[j]);
      }
    }
  }
}

void overlayDarkMids() {
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
      stroke(110);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b > 50 && b < 100 && distance > 2 && distance < 10) {
        line(x[i], y[i], x[j], y[j]);
      }
    }
  }
}

void overlayDarkMidsBig() {
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
      stroke(80);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b > 50 && b < 100 && distance > 20 && distance < 40) {
        line(x[i], y[i], x[j], y[j]);
      }
    }
  }
}

void overlayDarks() {
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
      stroke(0);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b < 40 && distance > 4 && distance < 25) {
        line(x[i], y[i], x[j], y[j]);
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

