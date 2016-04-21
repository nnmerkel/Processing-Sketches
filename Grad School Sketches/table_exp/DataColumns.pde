class DataColumns {
  //global data
  float sx, sy;

  DataColumns () {
  }

  void displayCartesian(float itemWidth, float amount[][], float theScale) {
    sx = 0;
    for (int i = 0; i < rowTotal; i++) {
      sx = itemWidth * i;
      sy = 0;
      for (int j = 0; j < itemCount; j++) {
        fill(fillHue, fillSaturation, fillBrightness, 100);
        strokeWeight(1);
        rect(sx, sy, itemWidth, log2(amount[i][j], logK) * theScale * axisReversal);
        if (normalize) sy += log2(amount[i][j], logK) * theScale * axisReversal;
        else sy += (amount[i][j]/theScale) * axisReversal;
      }
    }
  }

  void displayPolar(float itemWidth, float amount[][], float cx, float cy, float theScale) {
    sx = 0;
    float radius = 200;
    for (int i = 0; i < rowTotal; i++) {
      sx = sx + radians(itemWidth);
      if (normalize) {
        radius = log2(radius, logK)*theScale;
        sy = log2(amount[i][0], logK) * theScale + radius;
      } else {
        radius /= theScale;
        sy = (amount[i][0] + radius)/theScale;
      }
      for (int j = 0; j < itemCount; j++) {
        fill(fillHue, fillSaturation, fillBrightness * differential, 100);
        arc(cx, cy, sy, sy, sx, sx + radians(itemWidth));
        if (normalize) sy += log2(amount[i][j], logK) * theScale;
        else sy += amount[i][j]/theScale;
      }
    }
    if (hollow) {
      noStroke();
      fill(background);
      ellipse(cx, cy, radius, radius);
    }
  }

  void displayBezier(float itemWidth, float amount[][], float theScale) {
    float thisY = 0, nextY = 0;
    for (int i = 0; i < itemCount; i++) {
      //begin drawing
      beginShape();
      sx = 0;
      if (normalize) vertex(sx, log2(amount[0][i], logK) * theScale * axisReversal);
      else vertex(sx, (amount[0][i]/theScale) * axisReversal);

      for (int j = 0; j < rowTotal-1; j++) {
        stroke(strokeHue, strokeSaturation, strokeBrightness, 150);
        sx = itemWidth * j;
        if (normalize) {
          thisY = log2(amount[j][i], logK) * theScale * axisReversal;
          nextY = log2(amount[j+1][i], logK) * theScale * axisReversal;
        } else {
          thisY = (amount[j][i]/theScale) * axisReversal;
          nextY = (amount[j+1][i]/theScale) * axisReversal;
        }
        bezierVertex(sx += itemWidth/2, thisY, sx, nextY, sx += itemWidth/2, nextY);
      }
      endShape();
    }
  }

  void showAverage(float data[][], float theScale) {
    float entry, average;
    average = 0;
    for (int i = 0; i < rowTotal; i++) {
      for (int j = 0; j < itemCount; j++) {
        entry = data[i][j];
        average += entry;
      }
    }
    if (normalize) average = log2(average / rowTotal, logK) * theScale * axisReversal;
    else average = ((average / rowTotal) / theScale) * axisReversal;
    stroke(360, 100, 100);
    line(0, average, width, average);
  }

  float log2 (float x, float k) {
    return log(x) / log(k);
  }
}