class Point {
  PVector location;
  PVector velocity;
  PVector wind;
  float limitingFactor = 0.7;
  float deviation;

  Point () {
    location = new PVector(random(-width/2, width/2), random(-height/2, height/2));
    velocity = new PVector(random(-0.05, 0.05), random(-0.05, 0.05));
    deviation = random(-30.0, 30.0);
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
    stroke(242, 118, 48, 100);
    strokeWeight(strokeWeight);
    point(location.x, location.y);
  }
}