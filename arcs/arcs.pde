float a=0;
float b=0;
float c=0;
boolean grow1 = true;
boolean grow2 = true;
boolean grow3 = true;

void setup() {
  size(800, 800);
  smooth(10);
}



void draw() {
  background(255);

  //draw some arcs
  fill(0, 255, 0);
  arc(width/2, height/2, a, a, radians(0), radians(120));
  fill(0, 0, 255);
  arc(width/2, height/2, b, b, radians(120), radians(240));
  fill(0, 0, 0);
  arc(width/2, height/2, c, c, radians(240), radians(360));

  //arcs grow
  if (grow1==true) {
    a++;
  } else {
    a--;
  }
  if (grow2==true) {
    b+=.25;
  } else {
    b--;
  }
  if (grow3==true) {
    c+=.75;
  } else {
    c--;
  }

  //arcs stop growing?
  println("agrowth" + a);
  if (a>300 || a<0) {
    grow1=!grow1;
  }
  if (b>300 || b<0) {
    grow2=!grow2;
  }
  if (c>300 || c<0) {
    grow3=!grow3;
  }
}

