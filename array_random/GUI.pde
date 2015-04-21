
void setupGUI() {
cp5 = new ControlP5(this);
  Group g2 = cp5.addGroup("g2")
    .setPosition(10, 20)
      .setWidth(220)
        .setBackgroundColor(color(0, 60))
          .setBackgroundHeight(200)
            .setLabel("Menu");
  cp5.addSlider("total")
    .setPosition(0, 24)
      .setSize(200, 20)
        .setRange(100, 10000)
          .setValue(100)
            .setGroup(g2);
  cp5.addSlider("smallLimit")
    .setPosition(0, 0)
      .setSize(200, 20)
        .setRange(4, 500)
          .setGroup(g2);
  cp5.addSlider("lineSw")
    .setPosition(0, 48)
      .setSize(200, 20)
        .setRange(.5, 3.5)
          .setNumberOfTickMarks(7)
            .setGroup(g2);
  cp5.addSlider("pointSw")
    .setPosition(0, 72)
      .setSize(200, 20)
        .setRange(.5, 3.5)
          .setNumberOfTickMarks(7)
            .setGroup(g2);
  cp5.addToggle("falseColor")
    .setPosition(0, 120)
      .setSize(20, 20)
        .setGroup(g2);
  /*cp5.addColorPicker("falseSwatch")
    .setPosition(0, 180)
      .setColorValue(falseSwatch)
        .setGroup(g2);*/
  cp5.addRange("falseSwatch", 0, 720, 0, 100, 0, 204, 200, 15);
  cp5.addSlider("saturationValue", 0, 100, 0, 228, 200, 15);
  cp5.addSlider("brightnessValue", 0, 100, 0, 250, 200, 15);
}

void drawGUI() {
  cp5.show();
  cp5.draw();
}
