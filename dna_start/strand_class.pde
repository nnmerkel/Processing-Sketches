class Strand {
  float c = width/2;
  float ch = height/2;
  float rad = 8;
  //there are two randNum floats so the middle dots arent symmmetrical every iteration
  float randNum = random(0, 10);
  float randNum2 = random(0, 10);

  Strand () {
  }

  void bothFunctions () {
    partOne();
    partTwo();
  }

  //it goes to +x
  void partOne() {
    noStroke();
    if (randNum < 2) {
      noFill();
    } else {
      fill(0, 0, 0);
    }

    ellipse(c, ch, rad, rad);
  }

  //it goes to -x
  void partTwo() {
    noStroke();
    if (randNum2 < 2) {
      noFill();
    } else {
      fill(0, 0, 0);
    }
    ellipse(c, ch, rad, rad);
  }
}

