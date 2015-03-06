class Point {
  PVector location;
  PVector velocity;

  Point () {
    location = new PVector(x, y);
    velocity = new PVector(random(-3, 3), random(-3, 3));
  }

  float getCoordinates(float thisX, float thisY) {
    thisX = location.x;
    thisY = location.y;
  }

  void run() {
    location.add(velocity);
    if ((location.x > width) || (location.x < 0)) {
      velocity.x = velocity.x * -1;
    }
    if ((location.y > height) || (location.y < 0)) {
      velocity.y = velocity.y * -1;
    }
    stroke(0);
    strokeWeight(5);
    point(location.x, location.y);
  }
}

