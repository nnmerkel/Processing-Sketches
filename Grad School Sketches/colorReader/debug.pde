class Debug {
  //debug mode allows the user to access certain attributes about each dissection succinctly and from the same class
  //previously, I had numerous println()'s scattered throughout, but now I can just store info and print it all together

  int timesBroken;
  int imageWidth;
  int imageHeight;
  int sampledImageCount;
  int tileWidth;
  int tileHeight;
  int tileCount;
  long duration;
  float tolerance;

  Table dataFile;

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


  void logData() {
    // TODO: add function that checks to see if their is already a file named dataLog, and if there isn't make one
    dataFile = loadTable("dataLog.csv", "header, csv");

    TableRow row = dataFile.addRow();
    
    row.setInt("Master image width", imageWidth);
    row.setInt("Master image height", imageHeight);
    row.setInt("Master image resolution", imageWidth * imageHeight);
    row.setInt("Sampled image count", sampledImageCount);
    row.setString("Tile size", Integer.toString(tileWidth) + "x" + Integer.toString(tileHeight));
    row.setInt("Tile count", tileCount);
    row.setFloat("Tolerance", tolerance);
    row.setInt("Times broken", timesBroken);
    row.setLong("Duration", duration);
    
    saveTable(dataFile, "data/dataLog.csv");
  }
}