
PVector location;
PVector velocity;
PVector gravity;
PVector wind;

int d = 25;

void setup() {
  size(800, 800);
  smooth(8);

  location = new PVector(width/2, height/2);
  velocity = new PVector(3, 2);
  gravity = new PVector(0, .25);
  wind = new PVector(.00005, 0);
}



void draw() {
  background(205);
  
  gravity.add(wind);
  velocity.add(gravity);
  location.add(velocity);
  
  noStroke();
  fill(255);
  ellipse(location.x, location.y, d, d);
  fill(255, 0, 0);
  ellipse(location.x, location.y, 5, 5);

  if (location.x > width-d/2 || location.x < d/2) {
    velocity.x = velocity.x *= -1;
  }

  if (location.y > height-d/2 || location.y < d/2) {
    velocity.y = velocity.y *= -1;
  }
}

