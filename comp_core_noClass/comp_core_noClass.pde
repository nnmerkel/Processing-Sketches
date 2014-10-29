float r = 0;

void setup() {
  size(800, 800);
  smooth(8);
}



void draw() {
//  noStroke();
//  fill(255, 60);
//  rect(0, 0, width, height);
r = r++;
translate(width/2, height/2);
  arcF();
  arcF();
  arcF();
  noLoop();
  rotate(radians(r));
}

//function for a few arcs
void ring() {
  arcF();
}

//function for a single arc
void arcF() {
  float x = 0;
  float y = 0;
  float d = random(10, 700);
  float randNum = random(-180, 180);
  float randNum2 = random(-90, 270);
  float randStr = random(1, 10);

// alternate stroke color between orange and purple or whatever colors
  if (randStr <= 5) {
    stroke(179, 49, 136);
  } else {
    stroke(234, 137, 38);
  }

//random stroke weights for different arc thicknesses
  strokeWeight(random(2, 20));
  //square cap so it looks like an arc
  strokeCap(SQUARE);
  noFill();
  arc(0, 0, d, d, radians(randNum), radians(randNum2));
}

//save frame function
void keyPressed() {
  if (key == 's') {
    saveFrame();
    println("frame saved");
  }
}

