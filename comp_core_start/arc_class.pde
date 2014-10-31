class Arc {

  //global variables
  float bAngle = int(random(-180, 180));
  float eAngle = bAngle + int(random(0, 270));
  float d = int(random(40, height-100));
  float randStr = random(0, 10);
  float increment = random(1, 10);
  float r;
  float directionFunct = random(1, 10);
  float direction;

  Arc () {
    r = random(1, 10);
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
    if (randStr <= 5) {
      stroke(255, 70);
    } else {
      stroke(200, 80);
    }
    bAngle += increment * direction;
    eAngle += increment * direction;
    noFill();
    arc(x, y, d, d, radians(bAngle), radians(eAngle));
  }
}

