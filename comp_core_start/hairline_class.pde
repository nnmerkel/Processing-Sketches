class HairlineArc {

  //global variables
  float bAngle = int(random(-180, 180));
  //the shorter eAngle is, the shorter the arcs are
  //the shorter the arcs, the better the performance
  float eAngle = bAngle + int(random(0, 14));
  float d = int(random(300, height-50));
  float increment = random(.5, 3);
  float r;
  float directionFunct = random(1, 10);
  float direction;
  HairlineArc () {
    r = random(1, 3);
    if (directionFunct < 5) {
      direction = 1;
    } else {
      direction = -1;
    }
  }

  void run() {
    float x = 0;
    float y = 0;
    strokeWeight(r);
    strokeCap(SQUARE);
    stroke(179, 49, 136, 190); //purple
    //stroke(234, 137, 38, 180); //orange
    
    bAngle += increment * direction;
    eAngle += increment * direction;
    noFill();
    arc(x, y, d, d, radians(bAngle), radians(eAngle));
  }
}

