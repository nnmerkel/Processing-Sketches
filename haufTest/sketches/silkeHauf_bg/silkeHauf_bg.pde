/** Website animation for Silke Hauf //<>//
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

int lineDistance = 90;              // maximum distance between points for them to be connected
int numNodes = (int)random(4, 8);   // random number of nodes generated per page load
int ni = 0;                         // "nodeIndex" walks through the nodes array
int numPoints = 80;                 // number of points in the node
float nodeSize = 200;               // radius of the node

//speed
float param = 1.5;

long startTime, endTime, totalTime; // timing variables for division parameters
long targetTime = 10000; // time after which nodes can divide, in milliseconds

boolean longRunTime, denseEnough; // conditions for division
boolean reset;
boolean [] flags;

color c = color(242, 118, 48);

void setup() {
  size(800, 450);
  // note that pixeldensity changes how fast the vectors are. double pixels means an inverse proportionality in speed
  // check in p5js
  pixelDensity(2);
  noStroke();
  n = new Node[numNodes];
  for (int i = 0; i < numNodes; i++) {
    n[i] = new Node(width/2, height/2, nodeSize, numPoints);
    n[i].initPoints();
  }

  // flags moves each successive node to the animation thread
  flags = new boolean[numNodes-1];
}


void draw() {
  startTime = System.currentTimeMillis();
  noFill();
  background(205);
  n[0].node();

  //division loop; if the program has been running for more than x seconds and if there is a point with enough connections
  if (denseEnough && longRunTime) {
    flags[0] = true;
    reset = true;

    //reset the clock for the countdown so nodes dont keep spawning
    totalTime = 0;
  }

  //walk through the nodes array and if all conditions are met, make a new node
  for (int i = 0; i < numNodes-1; i++) {
    if (flags[i]) {
      if (reset) {
        n[i+1].resetParameters();
        reset = false;
      }

      n[i+1].node();
    }
    println(numNodes, i);
  }

  // try to write this as a function var in p5js
  endTime = System.currentTimeMillis();
  endTime -= startTime;
  totalTime += endTime;
  if (totalTime >= targetTime) {
    longRunTime = true;
  } else {
    longRunTime = false;
  }
}