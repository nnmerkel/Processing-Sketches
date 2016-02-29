/** Website animation for Silke Hauf
 * 
 * todo: point strokeweight related to number of lines joining to a point
 *       limit vector speed
 * 
 * 
 * 
 */

Point [] p;

int nodes = 15;
int lineDistance = 200;
int strokeWeight = 2;

void setup() {
  size(800, 450);
  pixelDensity(2);
  noStroke();
  p = new Point[nodes];
  for (int i = 0; i < nodes; i++) {
    p[i] = new Point();
  }
}


void draw() {
  noFill();
  stroke(0);
  background(205);

  for (int i = 0; i < nodes-2; i++) {
    p[i].run();
    for (int j = 0; j < nodes; j++) {
      // we need to grab the x and y coordinates of each point as well as the distance and angle between them
      // next we calculate how they relate and make decisions based on that
      float _x = p[i].location.x;
      float _y = p[i].location.y;
      float _x2 = p[j].location.x;
      float _y2 = p[j].location.y;
      float[] midpoint = getMidpoint(_x, _y, _x2, _y2);

      //distance from point to bezier control point
      //r must always be a function of the distance between the points so that large lines remain proportional
      //r will always be a positive number, even elsewhere in the sketch
      float r = dist(_x, _y, _x2, _y2);
      if (r <= lineDistance) {
        float opacityMap = map(r, 0, lineDistance, 255, 0);
        stroke(242, 118, 48, opacityMap);
        strokeWeight(1);
        point(_x, _y);
        point(_x2, _y2);
        line(_x, _y, _x2, _y2);
      }
    }
  }
}

//returns the x and y coordinates of the midpoint between any two given points
//2D only
float[] getMidpoint(float x1, float y1, float x2, float y2) {
  float[] result = {(x1 + x2) / 2, (y1 + y2) / 2};
  return result;
}