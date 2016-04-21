

void setup() {
  size(displayWidth, displayHeight, P2D);
  smooth(8);
  background(0);
  noStroke();
}


void draw() {
  fill(0);
  noStroke();
  rect(0, 0, 3000, 4000);
  frameRate(1);
  //these for loops are ridiculously complicated. much simpler version is network1
  /*for (int x = 0; x < width; x += 300) {
    if ((x < 700) && (x > 100)) {
      for (int y = 0; y < height; y += 300) {
        if ((y < 700) && (y > 100)) {
          float a = random(40, 140);
          float b = random(100, 700);
          float c = random(100, 700);
          fill(255);
          ellipse(b, c, a, a);
        }
      }
    }
  }*/
  network1();
  network1();
}



//circles and lines
void network1() {
//variables for the first circle
float radx1 = random(40, 200);
float xp1 = random(100, (width-100));
float yp1 = random(100, (height-100));
//variables for the second circle
float radx2 = random(40, 200);
float xp2 = random(100, (width-100));
float yp2 = random(100, (height-100));
//variables for the third circle
float radx3 = random(40, 200);
float xp3 = random(100, (width-100));
float yp3 = random(100, (height-100));
//variables for the fourth circle
float radx4 = random(40, 200);
float xp4 = random(100, (width-100));
float yp4 = random(100, (height-100));
//variables for the fifth circle
float radx5 = random(40, 200);
float xp5 = random(100, (width-100));
float yp5 = random(100, (height-100));
//variables for the sixth circle
float radx6 = random(40, 200);
float xp6 = random(100, (width-100));
float yp6 = random(100, (height-100));
//variables for the seventh circle
float radx7 = random(40, 200);
float xp7 = random(100, (width-100));
float yp7 = random(100, (height-100));

stroke(255);
//first line connect 1 and 2
strokeWeight(3);
line(xp1, yp1, xp2, yp2);
//connect 2 to 3
line(xp2, yp2, xp3, yp3);
//connect 4 to 2
line(xp2, yp2, xp4, yp4);
//connect 5 to 2
line(xp2, yp2, xp5, yp5);
//connect 6 to 2
line(xp2, yp2, xp6, yp6);
//connect 7 to 2
line(xp2, yp2, xp7, yp7);
//connect 5 to 7
line(xp5, yp5, xp7, yp7);
//connect 7 to 3
line(xp3, yp3, xp7, yp7);

//make it red
fill(xp1, 0, yp1);
noStroke();

//first circle
ellipse(xp1, yp1, radx1, radx1);
fill(0);
ellipse(xp1, yp1, (radx1-10), (radx1-10));
fill(xp1, 0, yp1);
ellipse(xp1, yp1, (radx1-50), (radx1-50));

//second circle
fill(xp2, 0, yp2);
ellipse(xp2, yp2, radx2, radx2);
fill(0);
ellipse(xp2, yp2, (radx2-10), (radx2-10));
fill(xp2, 0, yp2);
ellipse(xp2, yp2, (radx2-50), (radx2-50));

//third circle
fill(xp3, yp3, 0);
ellipse(xp3, yp3, radx3, radx3);
fill(0);
ellipse(xp3, yp3, (radx3-10), (radx3-10));
fill(xp3, yp3, 0);
ellipse(xp3, yp3, (radx3-50), (radx3-50));

//fourth circle
fill(0, yp4, xp4);
ellipse(xp4, yp4, radx4, radx4);
fill(0);
ellipse(xp4, yp4, (radx4-10), (radx4-10));
fill(0, yp4, xp4);
ellipse(xp4, yp4, (radx4-50), (radx4-50));

//fifth circle
fill(0, yp5, xp5);
ellipse(xp5, yp5, radx5, radx5);
fill(0);
ellipse(xp5, yp5, (radx5-10), (radx5-10));
fill(0, yp5, xp5);
ellipse(xp5, yp5, (radx5-50), (radx5-50));

//sixth circle
fill(0, xp6, yp6);
ellipse(xp6, yp6, radx6, radx6);
fill(0);
ellipse(xp6, yp6, (radx6-10), (radx6-10));
fill(0, xp6, yp6);
ellipse(xp6, yp6, (radx6-50), (radx6-50));

//seventh circle
fill(xp7, yp7, 0);
ellipse(xp7, yp7, radx7, radx7);
fill(0);
ellipse(xp7, yp7, (radx7-10), (radx7-10));
fill(xp7, yp7, 0);
ellipse(xp7, yp7, (radx7-50), (radx7-50));


}

//save frame function
void keyPressed() {
  if (key=='s') {
    saveFrame();
    println("frame saved");
  }
}
