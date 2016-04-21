class Ball {
  PVector location;
  PVector velocity;
  PVector gravity;
  PVector wind;
  float d = 10;



  Ball () {
    location = new PVector(random(d/2, width-d/2), d/2);
    velocity = new PVector(random(2, 5), random(1, 4));
    gravity = new PVector(0, random(.25, .35));
    wind = new PVector(random(-.02, .02), 0);
  }

  void run() {
    
    //gravity.add(wind);
    velocity.add(gravity);
    location.add(velocity);

    noStroke();
    fill(255);
    ellipse(location.x, location.y, d, d);
    fill(255, 0, 0);
    ellipse(location.x, location.y, 3, 3);
    stroke(location.y/2, 0, 0, 50);
    line(0, location.y, width, location.y);

    if (location.x > width-d/2 || location.x < d/2) {
      velocity.x = velocity.x *= -1;
    }

    if (location.y > height-d/2 || location.y < d/2) {
      velocity.y = velocity.y *= -1;
    }
  }
}

