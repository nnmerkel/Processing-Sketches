class Point {
  PVector location;
  PVector velocity;
  PVector wind;
  float limitingFactor = 1.0;
  float r;
  
  //connection counter
  int ccounter;
  
  // strokeweight var
  int psw;
  
  //speed
  float param = 1.5;

  Point () {
    //set location for the node
    location = new PVector();
    velocity = new PVector(random(-param, param), random(-param, param));
    r = 1;
    ccounter = 0;
    psw = 3;
  }

  void run() {
    wind = new PVector(random(-0.1, 0.1), random(-0.1, 0.1));
    location.add(velocity);
    velocity.add(wind);
    velocity.limit(limitingFactor);
    //if (location.x > width) location.x = 0;
    //if (location.y > height) location.y = 0;
    //if (location.x < 0) location.x = width;
    //if (location.y < 0) location.y = height;
    stroke(c, 200);
    strokeWeight(psw);
    point(location.x, location.y);
    noStroke();
    fill(c, 120);
    ellipse(location.x, location.y, r, r);
  }
}