float yoff = 0.0;
int increment = 20;
color from = color(94, 138, 180, 100);
color to = color(232, 119, 34, 255);
PImage p;


void setup() {
  size(800, 400);
  noStroke();
  p = loadImage("slide.jpeg");
}

void draw() {
  background(51);
  image(p, 0, 0);
  stroke(255);
  noFill();
  beginShape(); 

  float xoff = 0;
  for (float x = 0; x <= width; x += increment) {
    // Calculate a y value according to noise, map to 
    float y = map(noise(xoff, yoff), 0, 1, 60, 340);
    vertex(x, y);
    float size = map(y, 100, 300, 12, 1);
    strokeWeight(size);
    point(x, y);
    if (y < 150) {
      strokeWeight(2);
      ellipse(x, y, size*2.2, size*2.2);
    }
    stroke(51);
    strokeWeight(0);
    float step = map(x, 0, width, 0, 1);
    color fill = lerpColor(from, to, step);
    fill(fill);
    rect(x, y, increment, height);
    noFill();
    strokeWeight(1);
    stroke(255);
    xoff += 0.5;
  }
  // increment y dimension for noise
  yoff += 0.01;
  //vertex(width, height);
  //vertex(0, height);
  endShape();
}

