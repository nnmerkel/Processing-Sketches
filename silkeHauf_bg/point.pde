class Point {
  PVector location;
  PVector velocity;
  PVector wind;
  float limitingFactor = 1.0;
  float deviation;
  float r;
  int sw;
  float radius;
  //speed
  float param = 1.5;

  Point () {
    //set location for the node
    location = new PVector();
    velocity = new PVector(random(-param, param), random(-param, param));
    deviation = random(-30.0, 30.0);
    r = random(4, 10);
    sw = 3;
  }

  void run() {
    wind = new PVector(random(-0.1, 0.1), random(-0.1, 0.1));
    location.add(velocity);
    velocity.add(wind);
    velocity.limit(limitingFactor);
    radius = 200;
    //if (location.x > width) location.x = 0;
    //if (location.y > height) location.y = 0;
    //if (location.x < 0) location.x = width;
    //if (location.y < 0) location.y = height;
    stroke(242, 118, 48, 200);
    strokeWeight(sw);
    point(location.x, location.y);
    noStroke();
    fill(242, 118, 48, 120);
    ellipse(location.x, location.y, r, r);
  }
}