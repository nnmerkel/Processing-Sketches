

void setup () {
  size(100, 100);
  //PImage img = loadImage("/Users/EAM/GitHub/em-site/images/ae_dreams_cover.png");
  PImage img = loadImage("/Users/EAM/GitHub/em-site/images/idtheft-mockup1.jpg");
  boolean flag = isTransparent(img);
  println(flag);
}

void draw() {
}


boolean isTransparent(PImage img) {
  boolean result = false;
outerloop:
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int pixel = img.get(x, y);
      if ((pixel>>24) == 0x00) {
        result = true;
        break outerloop;
      } else {
        result = false;
      }
    }
  }
  return result;
}