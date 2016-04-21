//float x;
//float y;

PVector location;

//float xspeed = 5;
//float yspeed = 3;

PVector velocity;

int xdirection = 1;
int ydirection = 1;
int d = 50;

void setup() {
  size(800, 800);
  smooth(8);
  x = width/2;
  y = height/2;
}



void draw() {
  background(205);
  x = x + xspeed*xdirection;
  y = y + yspeed*ydirection;
  noStroke();
  fill(255);
  ellipse(x, y, d, d);
  fill(255, 0, 0);
  ellipse(x, y, 5, 5);

  if (x > width-d/2 || x < d/2) {
    xdirection *= -1;
  }

  if (y > height-d/2 || y < d/2) {
    ydirection *= -1;
  }
}

