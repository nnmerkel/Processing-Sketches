/** Website animation for Silke Hauf //<>//
 *  
 *  
 *  
 */

Node n;

//minimum distance between two points in order for them to be connected
int lineDistance = 100;

//density of the points
int numPoints = 260;

//speed of the points
float param = 2.0;

//colors
color positive = color(220);           //color of the actual nodes/points, greys
color negative = color(60, 91, 111);   //background
color accent = color(152, 0, 0);       //dark red
color accent2 = color(255, 102, 0);    //VT orange


void setup() {
  //size of the animation window
  size(800, 450);
  
  //only use pixelDensity on Retina displays, else comment it out
  pixelDensity(2);
  noStroke();
  
  //initialize our node
  n = new Node(width/2, height/2, numPoints);
  n.initPoints();
}


void draw() {
  noFill();
  background(negative);
  n.node();
  
  //these two statements save out each frame up to frame 180 as a PNG file.
  //i then took the frames into photoshop to compile them into a GIF.
  //comment them out if you don't want to save out each frame, as that 
  //can be computationally expensive and slow down your computer.
  saveFrame("small4_####.png");
  if (frameCount == 180) exit();
}