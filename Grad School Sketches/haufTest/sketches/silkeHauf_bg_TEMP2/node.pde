class Node {
  int pointsContained;
  float innerSquareSide, centerX, centerY;
  Point[] p;


  Node(float _centerX, float _centerY, int _pointsContained) {
    centerX = _centerX;
    centerY = _centerY;
    pointsContained = _pointsContained;
  }


  // initialize the points in each node
  void initPoints() {
    p = new Point[pointsContained];
    for (int i = 0; i < pointsContained; i++) {
      p[i] = new Point();
      //assign each point a random location
      setLocation(p[i]);
    }
  }
  
  
  //assign each point a random location
  PVector setLocation(Point p) {
    return p.location.set(random(-width/2, width/2), random(-height/2, height/2));
  }


  // create and run the node
  void node() {
    pushMatrix();
    
    //move the node to populate from the center outward
    translate(centerX, centerY);
    
    for (int i = 0; i < pointsContained; i++) {
      //reset the connection counter
      p[i].ccounter = 0;
      p[i].run();
      
      //limit the path of each point to remain in view
      if (p[i].location.x > width/2 || p[i].location.x < -width/2) p[i].location.x = random(-width/2, width/2);
      if (p[i].location.y > height/3 || p[i].location.y < -height/3) p[i].location.y = random(-height/3, height/3);
      float _x = p[i].location.x;
      float _y = p[i].location.y;

      //iterate through the points to evaluate distance
      for (int j = 0; j < pointsContained; j++) {
        float _x2 = p[j].location.x;
        float _y2 = p[j].location.y;
        //measure the distance between every point
        float r = dist(_x, _y, _x2, _y2);

        // create connections
        if (r <= lineDistance) {
          float opacityMap = map(r, 0, lineDistance, 255, 0);
          
          //let every fourth point be dark red
          if (i % 4 == 0) {
            stroke(accent, opacityMap);
            fill(accent, 150);
          } else if (i % 5 == 0) { //let every fifth point be orange
            stroke(accent2, opacityMap);
            fill(accent2, 150);
          } else { //every point in between will be white
            stroke(positive, opacityMap);
            fill(positive, 150);
          }
          
          strokeWeight(1);
          line(_x, _y, _x2, _y2);

          //count the connections
          p[i].ccounter++;
        }
      }

      //set point size to grow based on connections
      p[i].r = pow(1.15, p[i].ccounter);

      //limit the size of the disc so it's not absurdly large
      if (p[i].r > 15) p[i].r = 15;
    }
    popMatrix();
  }
}