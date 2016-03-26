/** Website animation for Silke Hauf //<>//
 * TEMPORARY PLACEHOLDER VERSION
 * todo: check pixeldensity detection in browsers
 *       check speed differences based on pixeldensity
 */

import java.util.Calendar;

Node [] n;

int lineDistance = 60;              // maximum distance between points for them to be connected
int numNodes = (int)random(3, 6);   // random number of nodes generated per page load
int numPoints = 150;                 // number of points in the node
float nodeSize = 200;               // radius of the node

//speed
float param = 1.5;

//swatches
color positive = color(220); //color of the actual nodes/points, greys
color negative = color(18, 37, 44); //background
color accent = color(152, 0, 0); //toggles when new node is formed
color accent2 = color(255, 102, 0); //sourcepoint indicator


void setup() {
  size(800, 450);
  pixelDensity(2);
  noStroke();
  n = new Node[numNodes];
  for (int i = 0; i < numNodes; i++) {
    n[i] = new Node(width/2, height/2, nodeSize, numPoints);
    n[i].initPoints();
  }
}


void draw() {
  noFill();
  background(negative);
  n[0].node();
  //saveFrame("example2_####.png");
  //if (frameCount == 100) exit();
}

void keyReleased() {
  if (key == 's' || key == 'S') {
    saveFrame("frame_####.png");
    println("frame saved");
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}