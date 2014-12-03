import processing.pdf.*;

PImage s;
int total = 8000;
int level = 0;
int [] x = new int[total];
int [] y = new int[total];

void setup() {
  size(884, 1024);//, PDF, "n1.pdf");
  s = loadImage("n2.jpg");
  background(0);
  //overlayDarkMids();
  overlayMidsSmall();
  overlayMidsBig();
  overlayLightMidsSmall();
  overlayLightMidsBig();
  overlayBrightsSmall();
  overlayBrightsBig();
}

void draw() {
  //saveFrame();
  //exit();
}

void overlayBrightsSmall() {
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
      if (redcc >= redc && b > 180 && distance > 2 && distance < 30) {
        line(x[i], y[i], x[j], y[j]);
      }
    }
  }
}

void overlayBrightsBig() {
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
      if (redcc >= redc && b > 180 && distance > 40 && distance < 100) {
        line(x[i], y[i], x[j], y[j]);
      }
    }
  }
}

void overlayMidsSmall() {
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
      stroke(100);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b > 100 && b < 150 && distance > 2 && distance < 20) {
        line(x[i], y[i], x[j], y[j]);
      }
    }
  }
}

void overlayMidsBig() {
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
      stroke(100);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b > 100 && b < 150 && distance > 40 && distance < 120) {
        line(x[i], y[i], x[j], y[j]);
      }
    }
  }
}

void overlayLightMidsSmall() {
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
      stroke(190);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b > 150 && b < 180 && distance > 6 && distance < 24) {
        line(x[i], y[i], x[j], y[j]);
      }
    }
  }
}

void overlayLightMidsBig() {
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
      stroke(190);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b > 150 && b < 180 && distance > 60 && distance < 120) {
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
      stroke(200);
      //point(x[i], y[i]);
      //point(x[j], y[j]);
      if (redcc >= redc && b > 30 && b < 90 && distance > 4 && distance < 30) {
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

