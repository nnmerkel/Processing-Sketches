class Node {
  int pointsContained;
  float innerSquareSide, centerX, centerY, nodeSize;


  Node(float _centerX, float _centerY, float _nodeSize, int _pointsContained) {
    centerX = _centerX;
    centerY = _centerY;
    nodeSize = _nodeSize;
    pointsContained = _pointsContained;
    //too much work to fit points exactly in the circle, so this is an approximation
    innerSquareSide = (nodeSize * sqrt(2)) / 2;
  }


  void initPoints() {
    p = new Point[pointsContained];
    for (int i = 0; i < pointsContained; i++) {
      p[i] = new Point();
      setLocation(p[i]);
    }
  }


  PVector setLocation(Point p) {
    return p.location.set(random(-innerSquareSide, innerSquareSide), random(-innerSquareSide, innerSquareSide));
  }


  void node() {
    pushMatrix();
    translate(centerX, centerY);
    for (int i = 0; i < pointsContained; i++) {
      //reset the connection counter
      p[i].ccounter = 0;
      p[i].run();
      float _x = p[i].location.x;
      float _y = p[i].location.y;
      for (int j = 0; j < pointsContained; j++) {
        float _x2 = p[j].location.x;
        float _y2 = p[j].location.y;
        float r = dist(_x, _y, _x2, _y2);
        
        // create connections
        if (r <= lineDistance) {
          float opacityMap = map(r, 0, lineDistance, 255, 0);
          stroke(242, 118, 48, opacityMap);
          strokeWeight(1);
          line(_x, _y, _x2, _y2);
          
          //count the connections
          p[i].ccounter++;
        }
        
        //set ellipse to grow based on connections
        //the 1.15 is a "best-look" constant. it can be changed according to preference
        p[i].r = pow(1.15, p[i].ccounter);
      }
      // keep the points in the bounds of the node
      if (p[i].location.mag() > nodeSize) {
        p[i].velocity.mult(-1);
      }
    }
    popMatrix();
  }
  
  
  void divide() {
    
  }
  
//end of class
}