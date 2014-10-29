class Arc {

  //initialize the parameters
  Arc () {

  }

  void run() {
    float x = 0;
    float y = 0;
    //cast random() variables as int() so you get a whole number
    float d = int(random(10, 400));
    float bAngle = int(random(-180, 180));
    float eAngle = bAngle + int(random(0, 270));
    float randStr = random(0, 10);
    noFill();
    strokeWeight(random(1, 10));
    strokeCap(SQUARE);
    if (randStr <= 5) {
      stroke(255, 0, 0);
    } else {
      stroke(0, 255, 0);
    }
    arc(x, y, d, d, radians(bAngle), radians(eAngle));
    bAngle ++;
    eAngle ++;
    println(bAngle, eAngle, d);
  }
}

