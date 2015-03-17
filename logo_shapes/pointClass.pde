class Point {
  PVector location;
  PVector velocity;
  PVector wind;

  Point () {
    location = new PVector(0, 0);
    velocity = new PVector(random(-.05, .05), random(-.05, .05));
    wind = new PVector(random(-.125, .125), random(-.125, .125));
  }

  void run() {
    location.add(velocity);
    //velocity.sub(wind);
    if (location.mag() > radius) {
      velocity.x = velocity.x * -1;
      velocity.y = velocity.y * -1;
    }
    stroke(30, 131, 216, 100);
    strokeWeight(strokeWeight);
    point(location.x, location.y);
  }
}

