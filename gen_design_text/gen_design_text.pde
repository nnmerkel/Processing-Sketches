PFont font;
int columnWidth = 12;
int columnHeight = 12;
int customSize = 10;
String message = "Generative Design Visualize, Program, and Create with Processing ";
String alphabet = "abcdefghijklmnopqrstuvwxyz";
char letter;
int index;

void setup() {
  size(800, 800);
  smooth();
  font = createFont("Monospaced", customSize, true);
  textFont(font);
  textAlign(CENTER, CENTER);
}

void draw() {
  for (int y = 0; y < width; y += columnHeight) {
    for (int x = 0; x < height; x += columnWidth) {
      float randomGen = random(0, 2);
      noFill();
      rect(x, y, columnWidth, columnHeight);
      fill(0);
      if(randomGen <= 1) {
        fill(0);
        text(message.charAt(index % message.length()), x+columnWidth/2, y+columnHeight/2);
      }
      else {
        fill(255, 0, 0);
        text(alphabet.charAt(int(random(0, alphabet.length()))), x+columnWidth/2, y+columnHeight/2);
      }
      index++;
    }
    //index = 0;
  }
  noLoop();
}

