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


  Debug () {
  }


  void logData() {
    // checks to see if their is already a file named dataLog, and if there isn't make one
    File f = new File(sketchPath("data/dataLog.csv"));
    if (f.exists() && !f.isDirectory()) { 
      dataFile = loadTable("dataLog.csv", "header, csv");
    } else {
      dataFile = new Table();
      
      dataFile.addColumn("Master image width");
      dataFile.addColumn("Master image height");
      dataFile.addColumn("Master image resolution");
      dataFile.addColumn("Sampled image count");
      dataFile.addColumn("Tile size");
      dataFile.addColumn("Tile count");
      dataFile.addColumn("Tolerance");
      dataFile.addColumn("Times broken");
      dataFile.addColumn("Duration");
      
      saveTable(dataFile, "data/dataLog.csv");
    }

    if (dataFile != null) {
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
    } else {
      println("there was an error writing debugging data to the file.");
    }
  }
}