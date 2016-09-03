PFont[] testFonts = new PFont[4];
PFont descFont, currentTestFont;
String string = "Ä{Processing|§°yp,.!W"; 
int fontSize = 35;
float stringWidth;
float textPosX = 10;
float textPosY;

int textHeight;

void setup() {
 //size(800,300, OPENGL);
 //size(800,300, P3D);
 size(800,300);
 background(0);

 testFonts[0] = createFont("Times New Roman", fontSize);
 testFonts[1] = createFont("Arial", fontSize);
 testFonts[2] = createFont("Courier", fontSize);
 testFonts[3] = createFont("Verdana", fontSize);
 descFont = createFont("Courier", 12);

 textPosY = height/3*2;
}

void draw() {
 background(0);

 currentTestFont = testFonts[int(4.0/width*mouseX)];
 fontSize = mouseY;
 textFont(currentTestFont, fontSize);
 stringWidth = textWidth(string);

 float baseline = textPosY;
 float descent = textPosY + textDescent();
 float ascent = textPosY - textAscent();
 float textHeight = textPosY-fontSize;

 // TEST STRING
 fill(255);
 text(string, textPosX,textPosY);

 // DESCRIPTIONS

 textFont(descFont);

 fill(200);
 text("Font, " + fontSize + "px", 10, height-20);
 // Vertical lines
 stroke(200);
 line(textPosX, textHeight-20, textPosX, descent+20);
 line(stringWidth+textPosX, textHeight-20, stringWidth+textPosX, descent+20);

 // Baseline
 fill(255,255,0);
 stroke(255,255,0);
 text("baseline", textPosX+stringWidth+30, baseline);
 line(textPosX,baseline, textPosX+stringWidth, baseline);
 line(textPosX+stringWidth, baseline,textPosX+stringWidth+30, baseline);

 // Descent
 fill(0,255,0);
 stroke(0,255,0);
 text("descent", textPosX+stringWidth+30, descent+20);
 line(textPosX,descent, textPosX+stringWidth,descent);
 line(textPosX+stringWidth,descent,textPosX+stringWidth+30, descent+20);

 // Fontsize (from baseline)
 fill(255,0,0);
 stroke(255,0,0);
 text("fontSize from baseline", textPosX+stringWidth+30, textHeight);
 line(textPosX,textHeight,textPosX+stringWidth, textHeight);
 line(textPosX+stringWidth, textHeight,textPosX+stringWidth+30, textHeight);

 // Ascent
 fill(0,0,255);
 stroke(0,0,255);
 text("ascent", textPosX+stringWidth+30, textHeight-30);
 line(textPosX,ascent,textPosX+stringWidth,ascent);
 line(textPosX+stringWidth,ascent,textPosX+stringWidth+30, textHeight-30);
}