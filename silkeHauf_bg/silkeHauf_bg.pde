/** Website animation for Silke Hauf
  * 
  * todo: point strokeweight related to number of lines joining to a point
  *       bezier connections
  *       limit vector speed
  * 
  * 
  * 
  */

Point [] p;

int total = 40;

int strokeWeight = 2;

void setup() {
  size(800, 450);
  pixelDensity(2);
  p = new Point[total];
  for (int i = 0; i < total; i++) {
    p[i] = new Point();
  }
}


void draw() {
  for (int i = 0; i < total; i++) {
    p[i].run();
    
    float _x = p[i].location.x;
    float _y = p[i].location.y;
    beginShape();
    vertex(_x, _y);
    bezierVertex();
  }
}