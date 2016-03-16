/** Website animation for Silke Hauf
 * WEBSITE TESTING VERSION
 * todo: check pixeldensity detection in browsers
 *       check speed differences based on pixeldensity
 * 
 * 
 * 
 */

import java.util.Arrays;

Point [] p;
Node [] n;

int lineDistance = 90;
int strokeWeight = 2;
int numNodes = (int)random(4, 8);
int iterator = 0;
int numPoints = 80;
float nodeSize = 200;

color c = color(242, 118, 48);

void setup() {
  size(800, 450);
  // note that pixeldensity changes how fast the vectors are. double pixels means an inverse proportionality in speed
  // check in p5js
  pixelDensity(2);
  noStroke();
  n = new Node[numNodes];
  n[0] = new Node(width/2, height/2, nodeSize, numPoints);
  n[0].initPoints();
}


void draw() {
  noFill();
  stroke(0);
  background(205);
  n[0].node(); //<>//
  
  //division loop
  /*if (hasDivided) {
    
    //add a node
    iterator++;
    
    //run everything as normal
    for (int i = 0; i < iterator; i++) {
      n[iterator].initPoints();
      n[iterator].node();
    }
  }*/
  //saveFrame("bounce2_####.png");
  //if (frameCount == 180) exit();
  //noLoop();
}