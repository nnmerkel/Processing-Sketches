class Points {

  Points() {
    for (int i = 0; i < total; i++) {
      for (int j = 0; j < total; j++) {
        for (int k = 0; k < total; k++) {
          x[i]=int(random(width));
          y[i]=int(random(height));
          z[i]=int(random(width));
          point(x[i], y[i], z[i]);
          point(x[j], y[j], z[j]);
          point(x[k], y[k], z[k]);
        }
      }
    }
  }

  void runPoints() {
    
  }
}