class Debug {
  //debug mode allows the user to access certain attributes about each dissection succinctly and from the same class
  //previously, I had numerous println()'s scattered throughout, but now I can just store info and print it all together

  int timesBroken;
  int imageWidth;
  int imageHeight;
  int imageResolution;
  int sampledImageCount;
  int tileWidth;
  int tileHeight;
  int tileCount;
  long duration;

  float tolerance;

  //int [] args = {timesBroken, imageWidth, imageHeight, imageResolution, sampledImageCount, tileWidth, tileHeight, tileCount, duration};

  Debug () {
    /*int _tB, int _iW, int _iH, int _iR, int _sIC, int _tW, int _tH, int _tC, int _d;
    float _t;
    timesBroken = _tB;
    imageWidth = _iW;
    imageHeight = _iH;
    imageResolution = _iR;
    sampledImageCount = _sIC;
    tileWidth = _tW;
    tileHeight = _tH;
    tileCount = _tC;
    duration = _d;
    tolerance = _t;*/
  }

  void printData() {
    System.out.printf("Master image width: %d\n", imageWidth);
    System.out.printf("Master image height: %d\n", imageHeight);
    System.out.printf("Master image resolution: %d\n", imageWidth * imageHeight);
    System.out.printf("Sampled image count: %d\n", sampledImageCount);
    System.out.printf("Tile size: %dx%d\n", tileWidth, tileHeight);
    System.out.printf("Tile count: %d\n", tileCount);
    System.out.printf("Tolerance: %f\n", tolerance);
    System.out.printf("Times broken: %d\n", timesBroken);
    System.out.printf("Duration: %d\n", duration);
  }
}