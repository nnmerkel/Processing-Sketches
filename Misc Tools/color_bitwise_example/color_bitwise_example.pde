color c = color(0, 0, 0);
color cc = color(10, 10, 40);

void setup () {
  //break the colors into R, G, B
  float comp1 = (c >> 16 & 0xFF) + (c >> 8 & 0xFF) + (c & 0xFF);
  float comp2 = (cc >> 16 & 0xFF) + (cc >> 8 & 0xFF) + (cc & 0xFF);

  float totaldiff = abs(comp1 - comp2);

  println(totaldiff);
}

void draw () {
}