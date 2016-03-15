/** Website animation for Silke Hauf
 * 
 * todo: 
 * 
 * 
 * 
 * 
 */

Point [] p;
Node [] n;

int lineDistance = 90;
int strokeWeight = 2;
int numNodes = 4;
int iterator = 0;
int numPoints = 80;
float nodeSize = 200;

void setup() {
  size(800, 450);
  pixelDensity(2);
  noStroke();
  n = new Node[numNodes];
  n[0].initPoints();
}


void draw() {
  noFill();
  stroke(0);
  background(205);
  n[0].node();
  
  //division loop
  if (hasDivided) {
    
    //add a node
    iterator++;
    
    //run everything as normal
    for (int i = 0; i < iterator; i++) {
      n[iterator].initPoints();
      n[iterator].node();
    }
  }
  //saveFrame("bounce2_####.png");
  //if (frameCount == 180) exit();
}