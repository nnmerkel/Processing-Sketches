PImage me;
int xincrement = 10;
int yincrement = 10;
int total = 12000;
int [] x = new int[total];
int [] y = new int[total];

void setup() {
  size(643, 960);
  smooth(8);
  me = loadImage("pp.jpg");
  image(me, 0, 0);
  for (int i = 0; i < width; i+=xincrement) {
    for (int j = 0; j < height; j+=yincrement) {
      x[i]=int(random(width));
      y[i]=int(random(height));
      PImage c = me.get(int(x[i]), int(y[i]), xincrement, yincrement);
      image(c, 0, 0);
      color cc = me.get(int(x[j]), int(y[j]), xincrement, yincrement);
      //float redc = red(c);
      //float redcc = red(cc);
      float b = brightness(cc);
      pushMatrix();
      translate(i, j);
      fill(b);
      rect(0, 0, i, j);
      popMatrix();
    }
  }
}


void draw() {
  rect(0, 0, 100, 100);
}

