class Point {
  PVector location;
  PVector velocity;
  PVector wind;

  Point () {
    location = new PVector(random(width), random(height));
    velocity = new PVector(random(-1, 1), random(-1, 1));
  }

  void run() {
    wind = new PVector(random(-0.15, 0.15), random(-0.15, 0.15));
    location.add(velocity);
    velocity.add(wind);
    velocity.limit(2.0);
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