/** Website animation for Silke Hauf
 * 
 * todo: point strokeweight related to number of lines joining to a point
 *       limit vector speed
 * 
 * 
 * 
 */

Point [] p;
Node n;

int nodes = 15;
int lineDistance = 70;
int strokeWeight = 2;

void setup() {
  size(800, 450);
  pixelDensity(2);
  noStroke();
  n = new Node(width/2, height/2, 200, 100);
  n.initPoints();
}


void draw() {
  noFill();
  stroke(0);
  background(205);
  n.node();
  saveFrame("bounce2_####.png");
  if (frameCount == 180) exit();
}