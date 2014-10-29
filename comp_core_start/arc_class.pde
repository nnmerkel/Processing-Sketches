class Arc {

  //initialize the parameters
  Arc () {

  }

  void run() {
    float x = width/2;
    float y = height/2;
    float d = random(10, 400);
    float bAngle = random(-180, 180);
    float eAngle = bAngle + random(0, 270);
    float randStr = random(0, 10);
    noFill();
    strokeWeight(random(1, 10));
    strokeCap(SQUARE);
    if (randStr <= 5) {
      stroke(255, 0, 0);
    } else {
      stroke(0, 255, 0);
    }
    bAngle ++;
    eAngle ++;
    arc(x, y, d, d, radians(bAngle), radians(eAngle));
  }
}

