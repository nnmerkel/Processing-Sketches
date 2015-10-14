float y = 0;

void setup () {
  size(800, 800);
  pixelDensity(2);
  println(log2(10000));
}

void draw() {
  for (int i = 0; i < height; i+=10) {
    y = log2(i);
    line(0, y, width, y);
  }
}

float log2 (int x) {
  return (log(x) / log(1.1));
}