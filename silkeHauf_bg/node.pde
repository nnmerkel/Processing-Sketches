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
      p[i].run();
      float _x = p[i].location.x;
      float _y = p[i].location.y;
      for (int j = 0; j < pointsContained; j++) {
        float _x2 = p[j].location.x;
        float _y2 = p[j].location.y;
        float r = dist(_x, _y, _x2, _y2);

        if (r <= lineDistance) {
          float opacityMap = map(r, 0, lineDistance, 255, 0);
          stroke(242, 118, 48, opacityMap);
          strokeWeight(1);
          line(_x, _y, _x2, _y2);
        }
      }
      if (p[i].location.mag() > nodeSize) {
        p[i].velocity.mult(-1);
      }
    }
    popMatrix();
  }
  
//end of class
}