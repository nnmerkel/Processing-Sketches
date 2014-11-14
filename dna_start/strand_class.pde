

class Strand {
  float c = 0;
  float ch = 0;
  //there are two randNum floats so the middle dots arent symmmetrical every iteration
  float randNum = random(0, 10);
  float randNum2 = random(0, 10);

  Strand () {
  }

  //create one middle strand section
  void middle() {
    // (total/(r+gap)) = total number of circles rendered per function
    int totalCircles = 100;
    //it goes to +x
    for (int i = 0; i < totalCircles; i+= (r+gap)) {
      pushMatrix();
      translate(i, 0);
      s[i].partOne();
      popMatrix();

      //it goes to -x
      pushMatrix();
      translate(-i, 0);
      //keep the second function in this loop partTwo so that the dots dont end up symmetrical
      s[i].partTwo();
      popMatrix();

      //ellipse(c+total, ch, 50, 50);
      //ellipse(c-total, ch, 50, 50);
    }
  }

  //it goes to +x
  void partOne() {
    noStroke();
    if (randNum < 2) {
      noFill();
    } else {
      fill(0, 0, 0);
    }

    ellipse(c, ch, r, r);
  }

  //it goes to -x
  void partTwo() {
    noStroke();
    if (randNum2 < 2) {
      noFill();
    } else {
      fill(0, 0, 0);
    }
    ellipse(c, ch, r, r);
  }
}

