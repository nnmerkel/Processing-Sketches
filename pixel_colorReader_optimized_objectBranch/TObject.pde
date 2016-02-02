class TileObject {
  int x;
  int y;
  float avgAttribute;
  float width = xIncrement;
  float height = yIncrement;
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
  
  void createTile() {
    //PImage i = sourceImage.get(x, y, width, height);
  }
  
  void printAttributes() {
    println("tileIndex " + tileIndex + "\n" + "x " + x + "\n" +"y " + y + "\n" + "avgAttribute " + avgAttribute + "\n" + "sourceImage " + sourceImage + "\n");
  }
  
}