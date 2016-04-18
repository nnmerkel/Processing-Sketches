/** Website animation for Silke Hauf //<>//
 * TEMPORARY PLACEHOLDER VERSION
 * todo: 
 *       
 */

Node n;

int lineDistance = 100;             // maximum distance between points for them to be connected
int numPoints = 200;// number of points in the node

//speed
float param = 2.0;

//swatches
color positive = color(220); //color of the actual nodes/points, greys
color negative = color(60, 91, 111); //background
color accent = color(152, 0, 0); //toggles when new node is formed
color accent2 = color(255, 102, 0);


void setup() {
  size(800, 450);
  pixelDensity(2);
  noStroke();
  n = new Node(width/2, height/2, numPoints);
  n.initPoints();
}


void draw() {
  noFill();
  background(negative);
  n.node();
  //saveFrame("small4_####.png");
  //if (frameCount == 180) exit();
}