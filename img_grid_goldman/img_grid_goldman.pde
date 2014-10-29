PImage goldman;

void setup() {
  size(600, 800);
  smooth(8);
  //load image and pixel info
  goldman = loadImage("g_oldman.jpg");
  goldman.loadPixels();
}


void draw() {
  image(goldman, 0, 0);
  //int area = goldman.width*goldman.height;

  //for (int i = 0; i < area; i += 2) {
  //goldman.pixels[i] = color(0, 0, 0);
  //}
  //goldman.updatePixels();


  for (int x = 0; x < width; x+=20) {
    for (int y = 0; y < height; y+=80) {
      float randx = random(100, 120);
      float compy;
      //supposedly, this formula makes the area of the rectangles always equal 100
      compy = 100/randx;
      
      //fill rect with color of center pixel behind it
      color c = get(x, y);
      fill(c);
      rectMode(CENTER);
      rect(x, y, random(100, 120), compy);
    }
  }
}


//draw a rectangle of variable height and width but constant area
void rectArea() {
  for (int x = 0; x < width; x+=20) {
    for (int y = 0; y < height; y+=80) {
      float randx = random(100, 120);
      float compy;
      //supposedly, this formula makes the area of the rectangles always equal 100
      compy = 100/randx;
      rectMode(CENTER);
      rect(x, y, randx, compy);
    }
  }
}

