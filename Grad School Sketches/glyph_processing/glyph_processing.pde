import java.util.Calendar;

PFont font;
String fontName = "AvenirNext-Bold";

int padding = 40;

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
  
  //A
  char c = (char)65;
  
  //size is larger than canvas so we can guarantee that the textWidth is greater than the width, thus triggering the next conditional
  //I may need to revisit this for super condensed fonts
  int size = int(width * 1.5);
  textSize(size);
  
  if (textWidth(c) > (width - padding)) {
    size *= (width / textWidth(c));
    size -= padding;
  }
  
  textSize(size);
  
  text(c, padding/2, (height - textDescent()) - padding/2);

  noFill();
  stroke(255, 0, 0, 50);
  
  //not sure why this rectangle is being drawn upward?
  rect(padding/2, (height - textDescent()) - padding/2, textWidth(c), -100);
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