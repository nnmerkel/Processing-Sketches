int guiWidth = 300;
int pad = 10;
int itemHeight = 20;
//buffer is so the title of the group is visible
int buffer = itemHeight+pad+10;

//col is hover and active state for buttons
color col = #72D3F5;

color fgActive = #00B4D6;

color bgActive = #00678B;

RadioButton r1;

Textlabel t;
Textlabel [] dpi = new Textlabel[2];


void setupGUI() {
  //ControlFont cfont = new ControlFont(font);
  //cp5.setControlFont(font);

  //we only need a close button if the program will run fullscreen
  //cp5.addButton("close")
  //.setPosition(width-itemHeight, 0);

  Group g2 = cp5
    .addGroup("g2")
    .setPosition(0, 0)
    .setWidth(guiWidth)
    .setBackgroundColor(color(55))
    //TODO: for some reason, this pane needs to be heaight+1 or there is a 1px line underneath it
    .setBackgroundHeight(height+1)
    .setLabel("Menu");

  t = cp5.addTextlabel("menu")
    .setText("Main Menu")
    .setPosition(pad, pad)
    .setGroup(g2)
    .setColorValue(160)
    .setFont(font);

  cp5.addButton("selectMaster")
    .setLabel("Choose master")
    .setPosition(pad, pad+buffer)
    .setSize(guiWidth-pad*2, itemHeight)
    .setColorBackground(bgActive)
    .setColorForeground(fgActive)
    .setColorActive(col);
  //.captionLabel().setControlFont().setFont(cfont);

  cp5.addButton("selectSamples")
    .setLabel("Choose Samples")
    .setPosition(pad, itemHeight+pad*2+buffer)
    .setSize(guiWidth-pad*2, itemHeight);

  cp5.addSlider("xIncrement")
    .setPosition(pad, itemHeight*2+pad*3+buffer)
    .setSize(guiWidth-pad*2, itemHeight-7)
    .setRange(2, 100)
    .setGroup(g2)
    .setValue(50);

  style("xIncrement", -60, 0);

  cp5.addSlider("yIncrement")
    .setPosition(pad, itemHeight*3+pad*4+buffer)
    .setSize(guiWidth-pad*2, itemHeight-7)
    .setRange(2, 100)
    .setGroup(g2)
    .setValue(50);

  style("yIncrement", -60, 0);

  cp5.addToggle("setMemLimit")
    .setPosition(pad, itemHeight*4+pad*5+buffer)
    .setSize(itemHeight, itemHeight)
    .setGroup(g2);

  style("setMemLimit", itemHeight+4, -itemHeight+2);

  cp5.addSlider("memLimit")
    .setPosition(pad, itemHeight*5+pad*6+buffer)
    .setSize(guiWidth-pad*2, itemHeight-7)
    .setRange(50, 100)
    .setGroup(g2)
    .setValue(80);

  style("memLimit", -50, 0);

  dpi[0] = cp5.addTextlabel("screen")
    .setPosition(pad, itemHeight*6+pad*7+buffer)
    .setGroup(g2)
    .setColorValue(170)
    .setSize(10, 10)
    .setFont(createFont("UniversLTStd-UltraCn.otf", 16));

  dpi[1] = cp5.addTextlabel("print")
    .setPosition((guiWidth/2)+pad, itemHeight*6+pad*7+buffer)
    .setGroup(g2)
    .setColorValue(170)
    .setFont(createFont("UniversLTStd-UltraCn.otf", 16));

  /*
  if (displayDensity() == 2) {
   dpi[0].setFont(createFont("UniversLTStd-UltraCn.otf", 9));
   dpi[1].setFont(createFont("UniversLTStd-UltraCn.otf", 9));
   }
   */

  r1 = cp5.addRadioButton("radioButton")
    .setPosition(pad, itemHeight*7+pad*8+buffer)
    .setSize(itemHeight, itemHeight)
    .setItemsPerRow(3)
    .setSpacingColumn(50)
    .setSpacingRow(pad)
    .addItem("red", 1)
    .addItem("green", 2)
    .addItem("blue", 3)
    .addItem("hue", 4)
    .addItem("saturation", 5)
    .addItem("brightness", 6)
    .addItem("color", 7)
    .setGroup(g2);

  cp5.addToggle("approximateWhite")
    .setPosition(pad, itemHeight*10+pad*11+buffer)
    .setSize(itemHeight, itemHeight)
    .setGroup(g2);

  style("approximateWhite", itemHeight+4, -itemHeight+2);

  cp5.addToggle("approximateBlack")
    .setPosition(pad, itemHeight*11+pad*12+buffer)
    .setSize(itemHeight, itemHeight)
    .setGroup(g2);

  style("approximateBlack", itemHeight+4, -itemHeight+2);

  cp5.addToggle("recursive")
    .setPosition(pad, itemHeight*12+pad*13+buffer)
    .setSize(itemHeight, itemHeight)
    .setGroup(g2);

  style("recursive", itemHeight+4, -itemHeight+2);

  cp5.addSlider("recursionLimit")
    .setPosition(pad, itemHeight*13+pad*14+buffer)
    .setSize(guiWidth-pad*2, itemHeight-7)
    .setRange(2, 10)
    .setGroup(g2)
    .setValue(4)
    .setNumberOfTickMarks(9);

  style("recursionLimit", -70, 0);

  cp5.addButton("dissect")
    .setPosition(pad, 600)
    .setSize(guiWidth-pad*2, itemHeight)
    .setGroup(g2);

  setLock(cp5.getController("selectSamples"), true);
  setLock(cp5.getController("xIncrement"), true);
  setLock(cp5.getController("yIncrement"), true);
  setLock(cp5.getController("setMemLimit"), true);
  setLock(cp5.getController("memLimit"), true);
  setLock(cp5.getController("red"), true);
  setLock(cp5.getController("green"), true);
  setLock(cp5.getController("blue"), true);
  setLock(cp5.getController("hue"), true);
  setLock(cp5.getController("saturation"), true);
  setLock(cp5.getController("brightness"), true);
  setLock(cp5.getController("color"), true);
  setLock(cp5.getController("approximateWhite"), true);
  setLock(cp5.getController("approximateBlack"), true);
  setLock(cp5.getController("recursive"), true);
  setLock(cp5.getController("recursionLimit"), true);
  setLock(cp5.getController("dissect"), true);
}


void setLock(Controller theController, boolean theValue) {
  if (theValue) {
    theController.setLock(theValue);
    theController.setColorBackground(color(170));
    theController.setColorForeground(color(40));
  } else {
    theController.setLock(theValue);
    theController.setColorBackground(bgActive);
    theController.setColorForeground(fgActive);
    theController.setColorActive(col);
  }
}


//redraw gui, but mostly just for the DPI readouts
void updateGUI() {
  float print = (float)round((xIncrement/300f) * 1000f) / 1000f;
  dpi[0].setText("Screen: " + xIncrement + "px");
  dpi[1].setText("Print: " + print + " in.");
}


//unchecks/checks radio buttons for mode selection
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(r1)) {
    int controller = (int)theEvent.getGroup().getValue() - 1;
    Arrays.fill(modes, false);
    modes[controller] = true;
  }
}


//move the labels around
void style(String theControllerName, int x, int y) {
  Controller c = cp5.getController(theControllerName);
  c.getCaptionLabel().getStyle().setMarginTop(y);
  c.getCaptionLabel().getStyle().setMarginLeft(x);
}