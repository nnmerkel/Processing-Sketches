class Node {
  int pointsContained, rand;
  float innerSquareSide, centerX, centerY, nodeSize;
  Point[] p;


  Node(float _centerX, float _centerY, float _nodeSize, int _pointsContained) {
    centerX = _centerX;
    centerY = _centerY;
    nodeSize = _nodeSize;
    pointsContained = _pointsContained;
    innerSquareSide = (nodeSize * sqrt(2)) / 2;
    rand = (int)random(pointsContained);
  }


  // initialize the points in each node
  void initPoints() {
    p = new Point[pointsContained];
    for (int i = 0; i < pointsContained; i++) {
      p[i] = new Point();
      if (i == rand) p[i].sourcePoint = true;
      setLocation(p[i]);
    }
  }
  
  
  PVector setLocation(Point p) {
    //return p.location.set(random(-innerSquareSide, innerSquareSide), random(-innerSquareSide, innerSquareSide));
    return p.location.set(random(-width/2, width/2), random(-height/2, height/2));
  }


  // create and run the node
  void node() {
    pushMatrix();
    translate(centerX, centerY);
    for (int i = 0; i < pointsContained; i++) {
      //reset the connection counter
      p[i].ccounter = 0;
      p[i].run();
      if (p[i].location.x > width/2) p[i].location.x = 0;
      if (p[i].location.y > height/2) p[i].location.y = 0;
      //if (p[i].location.x < 0) p[i].location.x = width;
      //if (p[i].location.y < 0) p[i].location.y = height;
      float _x = p[i].location.x;
      float _y = p[i].location.y;

      //iterate through the points to evaluate distance
      for (int j = 0; j < pointsContained; j++) {
        float _x2 = p[j].location.x;
        float _y2 = p[j].location.y;
        float r = dist(_x, _y, _x2, _y2);

        // create connections
        if (r <= lineDistance) {
          float opacityMap = map(r, 0, lineDistance, 255, 0);
          if (i % 5 == 0) {
            stroke(accent, opacityMap);
            fill(accent, 150);
          } else {
            stroke(positive, opacityMap);
            fill(positive, 150);
          }
          strokeWeight(1);
          line(_x, _y, _x2, _y2);

          //count the connections
          p[i].ccounter++;
        }
      }

      //set ellipse to grow based on connections
      //the 1.15 is a "best-look" constant. it can be changed according to preference
      p[i].r = pow(1.15, p[i].ccounter);

      if (p[i].sourcePoint) {
        stroke(accent2, 220);
        fill(accent2, 220);
        //ellipse(p[i].location.x, p[i].location.y, 50, 50);
      }

      //limit the size of the disc so it's not absurdly large
      if (p[i].r > 30) p[i].r = 30;
      
      if (p[i].location.mag() > width/2) {
        p[i].location.set(0, 0);
      }
    }
    popMatrix();
  }
}