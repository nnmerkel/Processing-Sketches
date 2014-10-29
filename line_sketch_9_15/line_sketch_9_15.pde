

void setup() {
  size(600, 600);
  smooth(8);
}





void draw() {
  background(255);
  
  for (int i=0; i<height; i+=10) {
    stroke(i, 0, 0);
    strokeWeight(i/50);
    ellipse(i-mouseY, i+mouseX, i, i);
  }
  for (int i=0; i<height; i+=10) {
    stroke(i, 0, i);
    strokeWeight(i/50);
    line(i-mouseY, 0, i-mouseX, 600);
  }
  for (int i=0; i<height; i+=10) {
    noFill();
    stroke(i);
  ellipse(300, 300, i, i);
  }
  fill(255);
  noStroke();
  ellipse(width/2, height/2, 300, 300);
  
  for(int i=0; i<height; i++) {
    pushMatrix();
  translate(0, i*10);
  line(100, 0, 500, 0);
  popMatrix();
  }
}

void keyPressed() {
if(key=='s') {
saveFrame("line_sketch_#####.tif");
println("frame saved");
}
}
