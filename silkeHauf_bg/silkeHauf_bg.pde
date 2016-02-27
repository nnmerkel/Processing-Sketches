/** Website animation for Silke Hauf
 * 
 * todo: point strokeweight related to number of lines joining to a point
 *       bezier connections
 *       limit vector speed
 * 
 * 
 * 
 */

Point [] p;

int total = 15;

int strokeWeight = 2;

void setup() {
  size(800, 450);
  pixelDensity(2);
  noStroke();
  p = new Point[total];
  for (int i = 0; i < total; i++) {
    p[i] = new Point();
  }
}


void draw() {
  noFill();
  stroke(0);
  background(205);

  for (int i = 0; i < total-2; i++) {
    p[i].run();
    // we need to grab the x and y coordinates of each point as well as the distance and angle between them
    // next we calculate how they relate and make decisions based on that
    float _x = p[i].location.x;
    float _y = p[i].location.y;
    float _x2 = p[i+1].location.x;
    float _y2 = p[i+1].location.y;
    float angle = atan2(_y2-_y, _x2-_x);
    float[] midpoint = getMidpoint(_x, _y, _x2, _y2);

    //distance from point to bezier control point
    //r must always be a function of the distance between the points so that large lines remain proportional
    //r will always be a positive number, even elsewhere in the sketch
    //float r = dist(_x, _y, midpoint[0], midpoint[1]);
    float r = dist(_x, _y, _x2, _y2);
    if (p[i].rand >= 1) r = -r;
    
    strokeWeight(1);
    beginShape();

    //pushMatrix();
    //rotate to face the second point
    //translate(_x, _y);
    //rotate(angle);
    
    vertex(_x, _y);
    bezierVertex(_x+r/3, _y+p[i].deviation, _x2+((r)/3), _y2+p[i+1].deviation, _x2, _y2);
    ellipse(_x+r/3, _y+p[i].deviation, 5, 5);
    ellipse(_x2+((r)/3), _y2+p[i+1].deviation, 5, 5);
    
    //popMatrix();

    endShape();
  }
}


//returns the x and y coordinates of the midpoint between any two given points
//2D only
float[] getMidpoint(float x1, float y1, float x2, float y2) {
  float[] result = {(x1 + x2) / 2, (y1 + y2) / 2};
  return result;
}