import processing.pdf.*;

//load the typeface
PFont type;

//set some global variables; these get used a lot
//change these if you alter the size() property so the curves dont look absurdly tiny
int functionHeight = 200;
int buffer = 20;
//lgbuffer puts the text under the curve of the correct color, rather than above
int lgbuffer = 16;
int cw = 20; //curve width



void setup() {
  //remember, change the global variables accordingly if you change the size()
  size(1400, 3150);//, "banner2.pdf"); //<--------did you remember to change the global variables???

  smooth(8);
  background(255);
  noFill();
  strokeWeight(1);
  //initialize the typeface
  type = createFont("Courier", 12, true);
}



void draw() {
  frameRate(1);

  //redraw the background
  background(255);

  //repeat curves horizontally and vertically
  //the increments addition acts as a buffer between the rows of curves; leave it so there is space for the letters
  for (int y = 0; y < height; y += functionHeight+buffer) {

    for (int x = 0; x < width; x += cw) {

      //'if' statement to change stroke color and letters
      float randNum = random(0, 100);
      //red
      if (randNum <= 25) {
        stroke(200, 0, 0);
        textFont(type, .75*cw);
        fill(200, 0, 0);
        text("T", x+.5*cw, y+functionHeight+lgbuffer);
      }

      //green
      if (randNum > 25 && randNum <= 50) {
        stroke(0, 102, 51);
        textFont(type, .75*cw);
        fill(0, 102, 51);
        text("A", x+.5*cw, y+functionHeight+lgbuffer);
      }

      //blue
      if (randNum > 50 && randNum <= 75) {
        stroke(0, 0, 200);
        textFont(type, .75*cw);
        fill(0, 0, 200);
        text("C", x+.5*cw, y+functionHeight+lgbuffer);
      }

      //black
      if (randNum > 75 && randNum <= 100) {
        stroke(0, 0, 0);
        textFont(type, .75*cw);
        fill(0, 0, 0);
        text("G", x+.5*cw, y+functionHeight+lgbuffer);
      } 

      pushMatrix();
      translate(x, y);
      noFill();
      smoothCurve();
      //draw a baseline; letters go under here
      stroke(0);
      strokeWeight(1.5);
      line(0, functionHeight+2, width, functionHeight+2);
      strokeWeight(1);
      stroke(180);
      line(0, functionHeight+5, width, functionHeight+5);
      popMatrix();
    }
  }
  //println("finished");
  //exit();
}

void smoothCurve() {
  //vary the height of the middle point and anchor points
  float tallPoint = random(5, functionHeight);
  //draw the actual curve
  beginShape();
  vertex(0, functionHeight);
  bezierVertex(.25*cw, functionHeight, .375*cw, tallPoint, .5*cw, tallPoint);
  bezierVertex(.625*cw, tallPoint, .75*cw, functionHeight, cw, functionHeight);
  endShape();
}

//save a frame
void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}