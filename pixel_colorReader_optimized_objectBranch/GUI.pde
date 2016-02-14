int guiWidth = 220;
int pad = 10;
int itemHeight = 20;
color col = color(127, 200, 22);
color bgActive = color(0, 94, 33);
color fgActive = color(0, 187, 66);

RadioButton r1;

void setupGUI() {
  //ControlFont cfont = new ControlFont(font);
  //cp5.setControlFont(font);

  Group g2 = cp5
    .addGroup("g2")
    .setPosition(0, 0)
    .setWidth(guiWidth)
    .setBackgroundColor(color(220))
    .setBackgroundHeight(height)
    .setLabel("Menu");

  cp5.addButton("selectMaster")
    .setLabel("Choose master")
    .setPosition(pad, pad)
    .setSize(guiWidth-pad*2, itemHeight)
    .setColorBackground(bgActive)
    .setColorForeground(fgActive)
    .setColorActive(col);
  //.captionLabel().setControlFont().setFont(cfont);

  cp5.addButton("selectSamples")
    .setLabel("Choose Samples")
    .setPosition(pad, itemHeight+pad*2)
    .setSize(guiWidth-pad*2, itemHeight);

  cp5.addSlider("xIncrement")
    .setPosition(pad, itemHeight*2+pad*3)
    .setSize(guiWidth-pad*2, itemHeight)
    .setRange(2, 100)
    .setGroup(g2)
    .setValue(50);

  cp5.addSlider("yIncrement")
    .setPosition(pad, itemHeight*3+pad*4)
    .setSize(guiWidth-pad*2, itemHeight)
    .setRange(2, 100)
    .setGroup(g2)
    .setValue(50);

  r1 = cp5.addRadioButton("radioButton")
    .setPosition(pad, itemHeight*4+pad*5)
    .setSize(itemHeight, itemHeight)
    .setItemsPerRow(7)
    .setSpacingColumn(pad)
    .addItem("red", 1)
    .addItem("green", 2)
    .addItem("blue", 3)
    .addItem("hue", 4)
    .addItem("saturation", 5)
    .addItem("brightness", 6)
    .addItem("color", 7)
    ;

  cp5.addButton ("dissect")
    .setPosition(pad, 600)
    .setSize(guiWidth-pad*2, itemHeight)
    .setGroup(g2);

  setLock(cp5.getController("selectSamples"), true);
  setLock(cp5.getController("xIncrement"), true);
  setLock(cp5.getController("yIncrement"), true);
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