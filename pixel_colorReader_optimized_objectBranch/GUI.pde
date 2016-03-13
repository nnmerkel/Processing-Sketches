int guiWidth = 220;
int pad = 10;
int itemHeight = 20;
int buffer = itemHeight+pad+10;
color col = color(127, 200, 22);
color bgActive = color(0, 94, 33);
color fgActive = color(0, 187, 66);

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
    .setBackgroundColor(color(220))
    .setBackgroundHeight(height)
    .setLabel("Menu");

  t = cp5.addTextlabel("menu")
    .setText("Main Menu")
    .setPosition(pad, pad)
    .setGroup(g2)
    .setColorValue(70)
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
    .setSize(guiWidth-pad*2, itemHeight)
    .setRange(2, 100)
    .setGroup(g2)
    .setValue(50);

  cp5.addSlider("yIncrement")
    .setPosition(pad, itemHeight*3+pad*4+buffer)
    .setSize(guiWidth-pad*2, itemHeight)
    .setRange(2, 100)
    .setGroup(g2)
    .setValue(50);

  dpi[0] = cp5.addTextlabel("screen")
    .setText("Screen " + (float)xIncrement/72 + " in.")
    .setPosition(pad, itemHeight*4+pad*5+buffer)
    .setGroup(g2)
    .setColorValue(170)
    .setSize(10, 10)
    .setFont(font);

  dpi[1] = cp5.addTextlabel("print")
    .setText("Print " + (float)xIncrement/300 + " in.")
    .setPosition((guiWidth/2)+pad, itemHeight*4+pad*5+buffer)
    .setGroup(g2)
    .setColorValue(170)
    .setFont(font);

  r1 = cp5.addRadioButton("radioButton")
    .setPosition(pad, itemHeight*5+pad*6+buffer)
    .setSize(itemHeight, itemHeight)
    .setItemsPerRow(3)
    .setSpacingColumn(50)
    .setSpacingRow(4)
    .addItem("red", 1)
    .addItem("green", 2)
    .addItem("blue", 3)
    .addItem("hue", 4)
    .addItem("saturation", 5)
    .addItem("brightness", 6)
    .addItem("color", 7)
    .setGroup(g2)
    ;

  cp5.addButton ("dissect")
    .setPosition(pad, 600)
    .setSize(guiWidth-pad*2, itemHeight)
    .setGroup(g2);

  setLock(cp5.getController("selectSamples"), true);
  setLock(cp5.getController("xIncrement"), true);
  setLock(cp5.getController("yIncrement"), true);
  setLock(cp5.getController("dissect"), true);
  setLock(cp5.getController("red"), true);
  setLock(cp5.getController("green"), true);
  setLock(cp5.getController("blue"), true);
  setLock(cp5.getController("hue"), true);
  setLock(cp5.getController("saturation"), true);
  setLock(cp5.getController("brightness"), true);
  setLock(cp5.getController("color"), true);
  setLock(cp5.getController("dissect"), true);
}

void setLock(Controller theController, boolean theValue) {
  if (theValue) {
    theController.setLock(theValue);
    theController.setColorBackground(color(170));
    theController.setColorForeground(color(50));
  } else {
    theController.setLock(theValue);
    theController.setColorBackground(bgActive);
    theController.setColorForeground(fgActive);
    theController.setColorActive(col);
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(r1)) {
    int controller = (int)theEvent.getGroup().getValue()-1;
    Arrays.fill(modes, false);
    modes[controller] = true;
  }
}