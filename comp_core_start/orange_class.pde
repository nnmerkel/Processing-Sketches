class OrangeArc {

  //global variables
  float bAngle = int(random(-180, 180));
  //the shorter eAngle is, the shorter the arcs are
  //the shorter the arcs, the better the performance
  float eAngle = bAngle + int(random(0, 90));
  float d = int(random(.1*width, .3*width));
  float increment = random(.1, 1);
  float r;
  float directionFunct = random(1, 10);
  float direction;
  OrangeArc () {
    r = random(10, 20);
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
    stroke(o); //orange
    
    bAngle += increment * direction;
    eAngle += increment * direction;
    noFill();
    arc(x, y, d, d, radians(bAngle), radians(eAngle));
  }
}

