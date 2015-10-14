class DataColumns {
  //global data
  float sx, sy, average;
  
  DataColumns () {
  }

  void displayCartesian(float itemWidth, float amount[][], float theScale) {
    sx = 0;
    for (int i = 0; i < rowTotal; i++) {
      sx = itemWidth * i;
      sy = 0;
      //for (int j = 0; j < itemCount; j++) {
        //colorMode(HSB, 360, 100, 100);
        strokeWeight(1);
        rect(sx, sy, itemWidth, amount[i][0]/theScale);
        sy += amount[i][0]/theScale;
      //}
    }
  }

  void displayPolar(float itemWidth, float amount[][], float cx, float cy, float theScale) {
    sx = 0;
    for (int i = 0; i < rowTotal; i++) {
      sx = itemWidth * i;
      sy = 0;
      for (int j = 0; j < itemCount; j++) {
        fill(j*70, 0, 0, 100);
        arc(cx, cy, sy, sy, sx, sx+radians(itemWidth));
        //scaleFactor = pow(2, j * 2);
        //println(scaleFactor);
        sy += amount[i][j]/theScale;
      }
    }
  }

  void displayPolarSingleItem(float itemWidth, float amount[][], float cx, float cy, int theIndex, float theScale) {
    sx = 0;
    sy = 0;
    for (int i = 0; i < rowTotal; i++) {
      sx = itemWidth * i;
      fill(i*10, 0, 0, 100);
      arc(cx, cy, sy, sy, sx, sx+radians(itemWidth));
      sy += amount[i][theIndex]/theScale;
    }
  }

  void displayBezier(float itemWidth, float amount[][], float theScale) {
    sx = 0;
    float thisY = 0, nextY = 0;
    int counter = 0;
    for (int i = 0; i < itemCount; i++) {
      nextY = thisY;
      
      //bezier properties
      colorMode(HSB, 360, 100, 100);
      stroke(i * 50, 80, 80);
      
      //begin drawing
      beginShape();
      vertex(sx, amount[0][i]/theScale);
      
      //reset the j count
      counter = 0;
      for (int j = counter; j < rowTotal-1; j++) {
        sx = itemWidth * j;
        thisY = amount[j][i]/theScale;
        nextY = amount[j+1][i]/theScale;
        bezierVertex(sx += itemWidth/2, thisY, sx, nextY, sx += itemWidth/2, nextY);
        strokeWeight(5);
        point(sx, amount[j][i]/theScale);
        strokeWeight(1);
        counter++;
      }
      endShape();
    }
  }

  float getAverage(float data[][]) {
    float entry, average;
    average = 0;
    for (int i = 0; i < rowTotal; i++) {
      for (int j = 0; j < itemCount; j++) {
        entry = data[i][j];
        average += entry;
      }
    }
    average = average / rowTotal;
    //println(average);
    return average;
  }
}