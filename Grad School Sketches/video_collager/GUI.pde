Textfield textfield;

int guiWidth = 200;

void setupGUI() {
  Group g = cp5
    .addGroup("g")
    .setPosition(0, 0)
    .setWidth(guiWidth)
    .setBackgroundColor(color(220))
    .setLabel("Options")
    ;

  textfield = cp5.addTextfield("Location Name:")
    .setPosition(0, 0)
    .setSize(guiWidth, 20)
    .setFocus(true)
    .setAutoClear(true)
    .setGroup(g)
    ;
}