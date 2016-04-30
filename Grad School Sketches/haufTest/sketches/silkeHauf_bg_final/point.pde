class Point {
  PVector location;
  PVector velocity;
  PVector wind;
  float r;
  
  //connection counter
  int ccounter;
  

  Point () {
    //set location for the node
    location = new PVector();
    
    //sets random speed for each point
    velocity = new PVector(random(-param, param), random(-param, param));
    
    //sets initial point size
    r = 1;
    ccounter = 0;
  }
  

  void run() {
    //the "wind" PVector adds a randomized motion to each point, so that
    //their motion is more fluid and organic.
    wind = new PVector(random(-0.1, 0.1), random(-0.1, 0.1));
    
    location.add(velocity);
    velocity.add(wind);
    
    //limit the speed so it doesn't get absurdly fast, but also add
    //speed as the program continues
    velocity.limit(param + 1.0);
    
    //styling options
    strokeWeight(3);
    point(location.x, location.y);
    noStroke();
    ellipse(location.x, location.y, r, r);
  }
}