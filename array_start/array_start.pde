import processing.pdf.*;

PImage s;
int total = 80000;
int maxArea, offset;
int [] x = new int[total];
int [] y = new int[total];

void setup() {
  size(620, 1080, PDF, "logo1.pdf");
  maxArea = height * width;
  s = loadImage("logo2.png");
  //image(s, 0, 0); 
}

void draw() {
  background(0); 
  //alternate function that will grab the color of each pixel, this is necessary for all
  //of my image editing ideas; before all else, i need to tell processing how to read the
  //image pixel by pixel
  //for (int colorGrab = 0; colorGrab < total; colorGrab++) {
    //offset = y[colorGrab]*width + x[colorGrab];
    //color c = s.pixels[offset];
    //float b = brightness(c);
  //}
  //gridDraw(5, 5);
  gridDraw2(12, 12);
  gridDraw2(17, 17);
  println("finished");
  exit();
}

//experiemntal function
void gridDrawX(int xincrement, int yincrement) {
  //get the color of each pixel
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      color c = s.pixels[j*width+i];

      //return value based on brightness of pixel
      float b = brightness(c);

      for (int x = 0; x < total; x+=xincrement) {
        for (int y = 0; y < total; y+=yincrement) {
          stroke(b);
          strokeWeight(3);
          point(x, y);
          //strokeWeight(1);
          //line(x, y, x+xincrement, y);
          //line(x, y, x, y+yincrement);
        }
      }
    }
  }
}

//each of these functions may repeat a lot of code, but they must be separate so that 
//xincrement and yincrement can be redinfed individually for each function
void gridDraw(int xincrement, int yincrement) {
  for (int x = 0; x < width; x+=xincrement) {
    for (int y = 0; y < height; y+=yincrement) {
      color c = s.pixels[y*width+x];
      float b = brightness(c);
      if (b > 40) {
        stroke(b);
        strokeWeight(2);
        point(x, y);
        strokeWeight(.5);
        line(x, y, x+xincrement, y);
        line(x, y, x, y+yincrement);
      }
    }
  }
}

void gridDraw2(int xincrement, int yincrement) {
  for (int x = 0; x < width; x+=xincrement) {
    for (int y = 0; y < height; y+=yincrement) {
      color c = s.pixels[y*width+x];
      float b = brightness(c);
      if (b > 100) {
        stroke(255);
        strokeWeight(3);
        point(x, y);
        strokeWeight(.5);
        line(x, y, x+xincrement, y);
        line(x, y, x, y+yincrement);
      }
    }
  }
}

void gridDraw3(int xincrement, int yincrement) {
  for (int x = 0; x < width; x+=xincrement) {
    for (int y = 0; y < height; y+=yincrement) {
      color c = s.pixels[y*width+x];
      float b = brightness(c);
      if (b > 220) {
        stroke(255);
        strokeWeight(7);
        point(x, y);
        strokeWeight(.5);
        line(x, y, x+xincrement, y);
        line(x, y, x, y+yincrement);
      }
    }
  }
}

void gridDraw4(int xincrement, int yincrement) {
  for (int x = 0; x < width; x+=xincrement) {
    for (int y = 0; y < height; y+=yincrement) {
      color c = s.pixels[y*width+x];
      float b = brightness(c);
      if (b > 140 && b < 200) {
        stroke(230);
        strokeWeight(3);
        point(x, y);
        strokeWeight(.5);
        line(x, y, x, y-yincrement);
        line(x, y, x-xincrement, y);
      }
    }
  }
}

