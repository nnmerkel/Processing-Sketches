import java.util.Calendar;

PFont font;
String fontName = "AvenirNextCondensed-UltraLight";

int padding = 80;

void setup() {
  size(800, 800);
  //String[] fontList = PFont.list();
  //printArray(fontList);
  font = createFont(fontName, 30);

  //33-126
  /*
  for (int i = 33; i < 34; i++) {
   char c = (char)i;
   int size = 800;
   if (textWidth(c) <= width) {
   size *= (width / textWidth(c)) - padding;
   }
   textSize(size);
   printGlyph(c);
   }
   */

  char c = (char)65;
  int size = 800;
  textSize(size);
  if (textWidth(c) <= width - padding) {
    size *= (width / textWidth(c));
    size -= padding;
  }
  textSize(size);
  textAlign(CENTER, CENTER);
  float h = height - textAscent() / 2;
  text(c, width/2, height/2);

  noFill();
  stroke(255, 0, 0, 50);
  rectMode(CENTER);
  rect(width/2, height/2, textWidth((char)65), textAscent());
}

void printGlyph(int c) {
  float h = textAscent();
  PGraphics g = createGraphics(width, height);
  g.beginDraw();
  g.fill(0);
  g.textSize(800);
  g.textAlign(CENTER, CENTER);
  g.text((char)c, width/2, height/2);
  g.endDraw();
  g.save(fontName + c + ".png");
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}