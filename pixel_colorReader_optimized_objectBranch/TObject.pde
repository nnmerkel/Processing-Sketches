class TileObject {
  int x;
  int y;
  float avgAttribute;
  PImage sourceImage;
  int tileIndex;
  
  
  //constructor
  TileObject (int _x, int _y, PImage _source, float _avg, int _i) {
    x = _x;
    y = _y;
    sourceImage = _source;
    avgAttribute = _avg;
    tileIndex = _i;
  }
  
  
  void printAttributes() {
    println("tileIndex " + tileIndex + "\n" + "x " + x + "\n" +"y " + y + "\n" + "avgAttribute " + avgAttribute + "\n" + "sourceImage " + sourceImage + "\n");
  }
  
}