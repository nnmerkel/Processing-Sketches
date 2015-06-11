class Point {
  PVector location;
  PVector velocity;
  PVector wind;

  Point () {
    location = new PVector(random(width), random(height));
    velocity = new PVector(random(-.05, .05), random(-.05, .05));
    wind = new PVector(random(-.125, .125), random(-.125, .125));
  }

  void run() {
    location.add(velocity);
    //velocity.sub(wind);
    /*if (location.mag() > radius) {
     velocity.x = velocity.x * -1;
     velocity.y = velocity.y * -1;
     }*/
    if (location.x >= width) location.x = 0;
    if (location.y >= height) location.y = 0;
    if (location.x <= 0) location.x = width;
    if (location.y <= 0) location.y = height;
    stroke(240, 240, 240, 10);
    //stroke(30, 131, 216, 100);
    strokeWeight(strokeWeight);
    point(location.x, location.y);
  }
}

