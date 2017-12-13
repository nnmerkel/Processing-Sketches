/**
 * Returns a random number normalized in a range the user can specify
 * Generated from a sampling of ambient noise with adustable threshold
 */

import controlP5.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
ControlP5 cp5;

float scale;
float threshold = 0.7;

//this needs to be float for the division later on
float indices;

int tripCounter;
boolean isPastThreshold = false;

int x = 0;
int y = 0;
int unit = 10;

void setup() {
  size(400, 400);
  scale = height/2;
  noStroke();

  minim = new Minim(this);
  cp5 = new ControlP5(this);

  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();

  cp5.addSlider("threshold")
    .setPosition(30, height-50)
    .setSize(200, 20)
    .setRange(-1, 1)
    .setValue(0.5);
}


void draw() {
  //background(0);
  //stroke(255);

  tripCounter = 0;
  indices = 0;
  isPastThreshold = false;

  // draw the waveforms just as a visualization
  for (int i = 0; i < in.bufferSize() - 1; i++) {
    //line(i, scale + in.left.get(i)*scale, i+1, scale + in.left.get(i+1)*scale);

    // both speakers need to be tripped to set off the flag
    // that way the source is uniform
    // because im ocd
    // and i like that shit
    if (in.left.get(i) >= threshold && in.right.get(i) >= threshold) {
      isPastThreshold = true;
      indices += i;
      tripCounter++;
      //println(i);
    }
  }
  
  indices /= tripCounter;

  if (isPastThreshold) {
    float n = getNewTrueRandom(indices, 0, 1);
    
    fill(n * 255);
    rect(x, y, unit, unit);
    x += unit;
    if (x >= width) {
      x = 0;
      y += unit;
    }
    noFill();
    
    println(n);
  }
}


float getNewTrueRandom(float incoming, float lowerLimit, float upperLimit) {
  //the 0 - 1024 comes form the size of the sound buffer
  return map(incoming, 0, 1024, lowerLimit, upperLimit);
}


void keyReleased() {
  if (key == 's' || key == 'S') {
    saveFrame("frame_####.png");
  }
}