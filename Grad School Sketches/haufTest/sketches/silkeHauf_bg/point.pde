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
  
  //is true if point qualifies to be a source point for a new node
  boolean sourcePoint;
  

  Point () {
    //set location for the node
    location = new PVector();
    velocity = new PVector(random(-param, param), random(-param, param));
    r = 1;
    ccounter = 0;
    psw = 3;
    sourcePoint = false;
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
    stroke(positive, 200);
    strokeWeight(psw);
    point(location.x, location.y);
    noStroke();
    fill(positive, 120);
    ellipse(location.x, location.y, r, r);
  }
}