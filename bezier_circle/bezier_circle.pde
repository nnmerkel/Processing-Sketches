


void setup() {
  size(1200, 800);
  smooth(8);
  background(240, 240, 220);
}



void draw() {
  //alpha background
  fill(250, 250, 230, 10);
  noStroke();
  rect(0, 0, width, height);
  strokeWeight(.5);

  //mainCircle();
  tangents();
}

//create the lines from the bezier curves
void tangents() {
  float cx1 = width/8;   //100
  float cy1 = height/8;
  float cx2 = width/2;   //400
  float cy2 = height/2;
  float cx3 = width/3.556;   //225
  float cy3 = height/3.556;
  float cx4 = width/1.39;   //575
  float cy4 = height/1.39;
  int steps = 50;
  for (int i = 0; i <= steps; i++) {
    float t = i / float(steps);
    // Get the location of the point
    float x = bezierPoint(cx1, cx1, cx3, cx2, t);
    float y = bezierPoint(cy2, cy3, cy1, cy1, t);
    // Get the tangent points
    float tx = bezierTangent(cx1, cx1, cx3, cx2, t);
    float ty = bezierTangent(cy2, cy3, cy1, cy1, t);
    // Calculate an angle from the tangent points
    float a = atan2(ty, tx);
    a += PI;
    stroke(0);
    float lng = 1000;
    line(x, y, cos(a)*lng + x, sin(a)*lng + y);
    // The following line of code makes a line 
    // inverse of the above line
    line(x, y, cos(a)*-lng + x, sin(a)*-lng + y);
    //include these lines if you want to see the exact tangency
    //stroke(0);
    //ellipse(x, y, 5, 5);
  }
}

//main shape that the lines will trace
void mainCircle() {
  beginShape();
  vertex(100, 400); //first point, left of circle
  bezierVertex(100, 225, 225, 100, 400, 100);
  bezierVertex(575, 100, 700, 225, 700, 400);
  bezierVertex(700, 575, 575, 700, 400, 700);
  bezierVertex(225, 700, 100, 575, 100, 400);
  endShape();
}




//save frame function
void keyPressed() {
  if (key=='s') {
    saveFrame();
    println("frame saved");
  }
}

