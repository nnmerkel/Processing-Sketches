class Point {
  PVector location;
  PVector velocity;
  PVector wind;
  float limitingFactor = 0.7;
  float deviation;
  float rand;

  Point () {
    //set location for the node
    location = new PVector(random(width), random(height));
    velocity = new PVector(random(-0.15, 0.15), random(-0.15, 0.15));
    deviation = random(-30.0, 30.0);
    rand = random(0, 2);
  }

  void run() {
    wind = new PVector(random(-0.015, 0.015), random(-0.015, 0.015));
    location.add(velocity);
    velocity.add(wind);
    velocity.limit(limitingFactor);
    /*if (location.mag() > radius) {
     velocity.x = velocity.x * -1;
     velocity.y = velocity.y * -1;
     }*/
    if (location.x > width) location.x = 0;
    if (location.y > height) location.y = 0;
    if (location.x < 0) location.x = width;
    if (location.y < 0) location.y = height;
    stroke(242, 118, 48, 200);
    strokeWeight(5);
    point(location.x, location.y);
  }
}