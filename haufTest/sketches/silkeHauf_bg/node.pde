class Node {
  int pointsContained;
  float innerSquareSide, centerX, centerY, nodeSize;


  Node(float _centerX, float _centerY, float _nodeSize, int _pointsContained) {
    centerX = _centerX;
    centerY = _centerY;
    nodeSize = _nodeSize;
    pointsContained = _pointsContained;

    //too much work to fit points exactly in the circle, so this is an approximation
    //that calculates the largest inscribed square (todo: quadrilateral) in the given bounds
    innerSquareSide = (nodeSize * sqrt(2)) / 2;
  }


  // initialize the points in each node
  void initPoints() {
    p = new Point[pointsContained];
    for (int i = 0; i < pointsContained; i++) {
      p[i] = new Point();
      setLocation(p[i]);
    }
  }


  // create points within the largest inscribed square (or quadrilateral) within specified shape
  PVector setLocation(Point p) {
    return p.location.set(random(-innerSquareSide, innerSquareSide), random(-innerSquareSide, innerSquareSide));
  }


  // create and run the node
  void node() {
    //set up the array to detect radius sizes
    float [] radii = new float[pointsContained];

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
          stroke(c, opacityMap);
          strokeWeight(1);
          line(_x, _y, _x2, _y2);

          //count the connections
          p[i].ccounter++;
        }
      }

      //set ellipse to grow based on connections
      //the 1.14 is a "best-look" constant. it can be changed according to preference
      p[i].r = pow(1.14, p[i].ccounter);
      
      //identify potential nodes; if there are more than "x" connections, it is a potential spawn point
      if (p[i].ccounter >= 20) {
        noFill();
        stroke(0, 0, 255, 200);
        ellipse(p[i].location.x, p[i].location.y, 50, 50);
      }
      
      //if it is large enough after the beginning of the sketch, make a new node
      if (p[i].ccounter >= 25) {
        noFill();
        stroke(0, 255, 0, 200);
        ellipse(p[i].location.x, p[i].location.y, 50, 50);
      }

      //load the radii array with sizes and then sort it
      radii[i] = p[i].r;

      // keep the points in the bounds of the node
      //the first condition is enough for processing, the second condition is a failsafe for browsers
      if (p[i].location.mag() > nodeSize ||
        dist(0, 0, p[i].location.x, p[i].location.y) >= nodeSize) {
        p[i].velocity.mult(-1);
      }
    }
    Arrays.sort(radii);
    popMatrix();
  }

  //end of class
}