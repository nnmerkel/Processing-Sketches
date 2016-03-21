/** Website animation for Silke Hauf //<>//
 * WEBSITE TESTING VERSION
 * todo: check pixeldensity detection in browsers
 *       check speed differences based on pixeldensity
 * 
 * 
 * 
 */

Node [] n;

int lineDistance = 90;              // maximum distance between points for them to be connected
int numNodes = (int)random(3, 6);   // random number of nodes generated per page load
int ni = 0;                         // "nodeIndex" walks through the nodes array
int numPoints = (int)random(50, 70);                 // number of points in the node
float nodeSize = 200;               // radius of the node

//speed
float param = 1.5;

long startTime, endTime, totalTime; // timing variables for division parameters
long targetTime = 8000; // time after which nodes can divide, in milliseconds

boolean longRunTime, denseEnough; // conditions for division
boolean reset; //toggles new node sequence
boolean [] flags; //array to toggle each individual node

//swatches
color positive = color(random(180, 255)); //color of the actual nodes/points
color negative = color(18, 37, 44); //background
color accent = color(152, 0, 0); //indicator for eligibility
color accent2 = color(255, 102, 0); //toggles when new node is formed

float newX, newY;

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
  flags = new boolean[numNodes];
}


void draw() {
  startTime = System.currentTimeMillis();
  noFill();
  background(negative);
  n[0].node();

  //division loop; if the program has been running for more than x seconds and if there is a point with enough connections
  if (denseEnough && longRunTime) {
    
    //if the program has added enough loops, kill them all
    if (ni+1 >= numNodes) {
      setAllFalse(flags);
      ni = 0;
    }
    
    //ensures that there is always at least one node running
    flags[ni] = true;
    
    // for each flag added, ni walks to the next place in the array and waits for the right conditions
    ni++;
    
    reset = true;

    //reset the clock for the countdown so nodes dont keep spawning
    totalTime = 0;
    printArray(flags);
  }

  //walk through the nodes array and if all conditions are met, make a new node
  for (int i = 0; i < numNodes-1; i++) {
    if (flags[i]) {
      if (reset) {
        n[i+1].resetParameters();
        reset = false;
      }
      
      //n[i+1].centerX = newX;
      //n[i+1].centerY = newY;
      pushMatrix();
      translate(newX, newY);
      n[i+1].node();
      popMatrix();
    }
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
  denseEnough = false;
}


//sets all booleans in the flags array to false
//this essentially resets the program
void setAllFalse(boolean [] b) {
  for (int i = 0; i < numNodes; i++) {
    b[i] = false;
  }
}