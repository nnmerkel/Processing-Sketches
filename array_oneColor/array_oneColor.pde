import processing.pdf.*;
import java.util.Calendar;

PImage s;
int total = 3000;
int [] x = new int[total];
int [] y = new int[total];
float bigLimit = 120;
float smallLimit = 100;
float smallLowLimit = 5;


void setup() {
  size(1620, 1050, PDF, "try19.pdf");
  pixelDensity(2);
  s = loadImage("2919705596_39e2860318_b.jpg");
  background(0);
  //overlayWide();
  overlay();
  smallLimit = 30;
  overlay();
  smallLimit = 15;
  overlay();
}


void draw() {
  //saveFrame();
  exit();
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
      if (redcc >= redc && b > 50 && b < 255 && distance > smallLowLimit && distance < smallLimit) {
        strokeWeight(.5);
        stroke(c);
        line(x[i], y[i], x[j], y[j]);
        strokeWeight(2);
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


String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}