PImage img;
PFont font;
float hue, saturation, brightness, a;
color r, g, b;
String text = "This is my text. It will go over the image";

void setup() {
  size(600, 909);
  pixelDensity(2);
  
  img = loadImage("g_oldman.jpg");
  font = createFont("UniversLTStd-UltraCn.otf", 14);
  textFont(font);
}

void draw() {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y+=10) {
      r = red(img.get(x, y));
      println(r);
    }
  }
  noLoop();
}