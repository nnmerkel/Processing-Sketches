/** Website animation for Silke Hauf //<>//
 * TEMPORARY PLACEHOLDER VERSION
 * todo: check pixeldensity detection in browsers
 *       check speed differences based on pixeldensity
 */

Node [] n;

int lineDistance = 100;              // maximum distance between points for them to be connected
int numNodes = (int)random(3, 6);   // random number of nodes generated per page load
int numPoints = 180;// number of points in the node

//speed
float param = 1.8;

//swatches
color positive = color(220); //color of the actual nodes/points, greys
color negative = color(60, 91, 111); //background
color accent = color(152, 0, 0); //toggles when new node is formed
color accent2 = color(48, 80, 32); //sourcepoint indicator


void setup() {
  size(800, 450);
  pixelDensity(2);
  noStroke();
  n = new Node[numNodes];
  for (int i = 0; i < numNodes; i++) {
    n[i] = new Node(width/2, height/2, numPoints);
    n[i].initPoints();
  }
}


void draw() {
  noFill();
  background(negative);
  n[0].node();
  saveFrame("small3_####.png");
  if (frameCount == 180) exit();
}