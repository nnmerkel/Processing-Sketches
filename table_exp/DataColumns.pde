class DataColumns {
  //global data
  float sx, sy, bx, by, average;
  //constructor; "setup"
  DataColumns () {
  }

  //render some data
  //columnX is the beginning position for each column, set by elementWidth*i
  //initialY should probably always equal 0, might not even need it to be a variable
  //itemWidth = elementWidth
  //amount[][] is a double array tracking itemCount and the designated entry
  void displayCartesian(float itemWidth, float amount[][]) {
    sx = 0;
    for (int i = 0; i < rowTotal; i++) {
      sx = elementWidth * i;
      sy = 0;
      for (int j = 0; j < itemCount; j++) {
        colorMode(HSB, 360, 100, 100);
        //fill(sy % 360, 90, 90);
        rect(sx, sy, itemWidth, amount[i][j]/scaleFactor);
        sy += amount[i][j]/scaleFactor;
      }
    }
  }

  void displayPolar(float itemWidth, float amount[][], float ax, float ay) {
    noFill();
    sx = 0;
    for (int i = 0; i < rowTotal; i++) {
      sx = itemWidth * i;
      sy = 0;
      for (int j = 0; j < itemCount; j++) {
        //by = amount[i][j]/scaleFactor;
        fill(100, 100);
        arc(ax, ay, sy, sy, sx, sx+radians(itemWidth));
        //println("by", by, "bx", bx, bx + itemWidth);
        sy += amount[i][j]/scaleFactor;
      }
    }
  }

  void displayBezier(float itemWidth, float amount[][]) {
    sx = 0;
    for (int i = 0; i < rowTotal; i++) {
      sx = itemWidth * i;
      sy = 0;
      for (int j = 0; j < itemCount; j++) {
        bezier(sx, sy, itemWidth, sy, sx, amount[i][j]/scaleFactor, sx + (itemWidth/2), amount[i][j]/scaleFactor);
        sy += amount[i][j]/scaleFactor;
      }
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