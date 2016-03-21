class Node {
  int pointsContained, rand;
  float innerSquareSide, centerX, centerY, nodeSize;
  Point[] p;


  Node(float _centerX, float _centerY, float _nodeSize, int _pointsContained) {
    centerX = _centerX;
    centerY = _centerY;
    nodeSize = _nodeSize;
    pointsContained = _pointsContained;
    rand = (int)random(pointsContained);
    
    positive = color(random(180, 255));

    //too much work to fit points exactly in the circle, so this is an approximation
    //that calculates the largest inscribed square (todo: quadrilateral) in the given bounds
    innerSquareSide = (nodeSize * sqrt(2)) / 2;
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
  
  
  void initSecondaryPoints() {
    p = new Point[pointsContained];
    for (int i = 0; i < pointsContained; i++) {
      p[i] = new Point();
      setOrigin(p[i]);
    }
  }


  // create points within the largest inscribed square (or quadrilateral) within specified shape
  PVector setLocation(Point p) {
    return p.location.set(random(-innerSquareSide, innerSquareSide), random(-innerSquareSide, innerSquareSide));
  }
  
  
  //sets the origin point for all nodes other than the first
  PVector setOrigin(Point p) {
    return p.location.set(0, 0);
  }
  
  
  void resetParameters() {
    for (int i = 0; i < pointsContained; i++) {
      p[i].location.set(0, 0);
      p[i].velocity.set(random(-param, param), random(-param, param));
      //p[i].wind.set(random(-0.1, 0.1), random(-0.1, 0.1));
    }
  }


  // create and run the node
  void node() {
    //denseEnough = false;
    //shift the coordinates to the origin of the node
    pushMatrix();
    translate(centerX, centerY);

    for (int i = 0; i < pointsContained; i++) {
      //reset the connection counter
      p[i].ccounter = 0;
      p[i].run();
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
          stroke(positive, opacityMap);
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
        ellipse(p[i].location.x, p[i].location.y, 50, 50);
      }
      
      //limit the size of the disc so it's not absurdly large
      if (p[i].r > 30) p[i].r = 30;
      
      //if it is large enough after the beginning of the sketch, activate the flag that will trigger a node
      if (p[i].ccounter >= 16 && p[i].sourcePoint) {
        denseEnough = true;
        stroke(accent, 100);
        ellipse(p[i].location.x, p[i].location.y, 30, 30);
        newX = p[i].location.x;
        newY = p[i].location.y;
      }

      // keep the points in the bounds of the node
      //the first condition is enough for processing, the second condition is a failsafe for browsers
      if (p[i].location.mag() > nodeSize ||
        dist(0, 0, p[i].location.x, p[i].location.y) >= nodeSize) {
        p[i].velocity.mult(-1);
      }
    }
    popMatrix();
  }

  //end of class
}