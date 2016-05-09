PFont font;

void setup() {
size(800, 800);
pixelDensity(2);
//String[] fontList = PFont.list();
//printArray(fontList);
font = createFont("AvenirNextCondensed-UltraLight", 100, true);
}

void draw() {
textSize(400);
textAlign(CENTER);
text("text", width/2, 700);
}