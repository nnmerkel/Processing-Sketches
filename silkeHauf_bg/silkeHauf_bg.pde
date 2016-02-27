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

int total = 4;

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
  noStroke();
  noFill();
  background(205);

  /*for (int i = 0; i < total-1; i++) {
   //p[i].run();
   // we need to grab the x and y coordinates of each point as well as the distance and angle between them
   // next we calculate how they relate and make decisions based on that
   float _x = p[i].location.x;
   float _y = p[i].location.y;
   float _x2 = p[i+1].location.x;
   float _y2 = p[i+1].location.y;
   float[] midpoint = getMidpoint(_x, _y, _x2, _y2);
   float angle = atan2(_y2 - _y, _x2 - _x);
   float validRange1 = angle + radians(p[i].deviation);
   float validRange2 = angle + PI + radians(p[i+1].deviation);
   
   pushMatrix();
   translate(_x, _y);
   rotate(angle);
   
   point(0, 0);
   strokeWeight(1);
   
   beginShape();
   vertex(0, 0);
   bezierVertex(midpoint[0] * cos(validRange1), midpoint[1] * sin(validRange1), midpoint[0] * cos(validRange2), midpoint[1] * sin(validRange2), _x2, _y2);
   endShape();
   
   strokeWeight(2);
   point(_x2, _y2);
   
   popMatrix();
   p[i].run();
   println(degrees(angle), p[i].deviation, midpoint[0] * cos(validRange1), midpoint[1] * sin(validRange1) + "\n");
   }*/
  stroke(0);
  strokeWeight(1);
  float x = 100;
  float y = 40;
  float d = radians(30.0);
  //beginShape();
  //vertex(0, 0);
  //bezierVertex(0, 100, 400, 300, 400, 400);
  //endShape();

  float angle = atan2(mouseY-y, mouseX-x);
  float[] midpoint = getMidpoint(x, y, mouseX, mouseY);
  
  //distance from point to bezier control point
  float d2 = dist(x, y, midpoint[0], midpoint[1]);
  
  //temp line for example, will be replaced by bezier function
  line(x, y, mouseX, mouseY);
  strokeWeight(5);

  pushMatrix();
  //rotate to face the second point
  translate(x, y);
  rotate(angle);
  arc(0, 0, d2, d2, 0, d);
  //remember that arcs always go clockwise, so the mirror must go from -deviation to 0
  arc(0, 0, d2, d2, -d, 0);
  popMatrix();
  
  pushMatrix();
  //move to the second point
  translate(mouseX, mouseY);
  stroke(255, 0, 0);
  point(0, 0);
  
  //rotate it back along the line to face the second point
  rotate(PI + angle);
  
  //show valid ranges
  arc(0, 0, d2, d2, -d, 0);
  arc(0, 0, d2, d2, 0, d);
  popMatrix();
}


//returns the x and y coordinates of the midpoint between any two given points
//2D only
float[] getMidpoint(float x1, float y1, float x2, float y2) {
  float[] result = {(x1 + x2) / 2, (y1 + y2) / 2};
  return result;
}