class Point {
  PVector location;
  PVector velocity;
  PVector wind;
  float r;
  
  //connection counter
  int ccounter;
  
  //is true if point qualifies to be a source point for a new node
  boolean sourcePoint;
  

  Point () {
    //set location for the node
    location = new PVector();
    velocity = new PVector(random(-param, param), random(-param, param));
    r = 1;
    ccounter = 0;
    sourcePoint = false;
  }
  

  void run() {
    wind = new PVector(random(-0.1, 0.1), random(-0.1, 0.1));
    location.add(velocity);
    velocity.add(wind);
    velocity.limit(param+.3);
    //stroke(positive, 200);
    strokeWeight(3);
    point(location.x, location.y);
    noStroke();
    //fill(positive, 120);
    ellipse(location.x, location.y, r, r);
  }
}