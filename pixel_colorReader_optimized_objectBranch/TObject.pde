class TileObject {
  int x;
  int y;
  float avgAttribute;
  float width = xIncrement;
  float height = yIncrement;
  PImage sourceImage;
  int tileIndex;
  
  //constructor
  TileObject () {
    
  }
  
  void createTile() {
    //PImage i = sourceImage.get(x, y, width, height);
  }
  
  void printAttributes() {
    println("tileIndex " + tileIndex + "\n" + "x " + x + "\n" +"y " + y + "\n" + "avgAttribute " + avgAttribute + "\n" + "sourceImage " + sourceImage + "\n");
  }
  
}