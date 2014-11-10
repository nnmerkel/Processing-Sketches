class PurpleArc {

  //global variables
  float bAngle = int(random(-180, 180));
  //the shorter eAngle is, the shorter the arcs are
  //the shorter the arcs, the better the performance
  float eAngle = bAngle + int(random(0, 40));
  float d = int(random(150, height-400));
  float increment = random(.5, 3);
  float r;
  float directionFunct = random(1, 10);
  float direction;
  PurpleArc () {
    r = random(8, 16);
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
    stroke(179, 49, 136, 190); //purple
    //stroke(234, 137, 38, 180); //orange
    
    bAngle += increment * direction;
    eAngle += increment * direction;
    noFill();
    arc(x, y, d, d, radians(bAngle), radians(eAngle));
  }
}

