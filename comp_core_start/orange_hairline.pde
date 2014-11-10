class OrangeHairlineArc {

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
  OrangeHairlineArc () {
    r = random(3, 8);
    if (directionFunct < 10) {
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
    stroke(234, 137, 38, 220);
    
    bAngle += increment * direction;
    eAngle += increment * direction;
    noFill();
    arc(x, y, d, d, radians(bAngle), radians(eAngle));
  }
}

