void setupGUI() {
  ControlGroup options = cp5.addGroup("options").setPosition(10, 20).setWidth(280).setBackgroundHeight(200).setLabel("Menu");

  sliders = new Slider[20];
  ranges = new Range[10];
  toggles = new Toggle[10];

  int si = 0;
  //int ri = 0;
  int ti = 0;

  toggles[ti++] = cp5.addToggle("usePolar").setPosition(4, 4).setSize(15, 15).setGroup(options);
  style("usePolar");
  toggles[ti++] = cp5.addToggle("useCartesian").setPosition(4, 23).setSize(15, 15).setGroup(options);
  style("useCartesian");
  toggles[ti++] = cp5.addToggle("useBezier").setPosition(4, 42).setSize(15, 15).setGroup(options);
  style("useBezier");
  toggles[ti++] = cp5.addToggle("useRadialGrid").setPosition(142, 4).setSize(15, 15).setGroup(options);
  style("useRadialGrid");
  toggles[ti++] = cp5.addToggle("useGrid").setPosition(142, 23).setSize(15, 15).setGroup(options);
  style("useGrid");
  toggles[ti++] = cp5.addToggle("average").setPosition(142, 42).setSize(15, 15).setGroup(options);
  style("average");
  toggles[ti++] = cp5.addToggle("normalize").setPosition(142, 61).setSize(15, 15).setGroup(options);
  style("normalize");
  /*radio = cp5.addRadioButton("radiobutton").setPosition(4,4).setSize(15, 15).setItemsPerRow(1).setSpacingRow(4)
         .addItem("usePolar", 1)
         .addItem("useCartesian", 2)
         .addItem("useBezier", 3)
         .setGroup(options);*/

  
  //sliders[si++] = cp5.addSlider("logK").setPosition(4, 80).setSize(272, 15).setGroup(options);
  sliders[si++] = cp5.addSlider("strokeHue").setPosition(4, 99).setSize(272, 15).setRange(0, 360).setGroup(options);
  sliders[si++] = cp5.addSlider("strokeSaturation").setPosition(4, 118).setSize(272, 15).setRange(0, 100).setGroup(options);
  sliders[si++] = cp5.addSlider("strokeBrightness").setPosition(4, 137).setSize(272, 15).setRange(0, 100).setGroup(options);
  sliders[si++] = cp5.addSlider("fillHue").setPosition(4, 156).setSize(272, 15).setRange(0, 360).setGroup(options);
  sliders[si++] = cp5.addSlider("fillSaturation").setPosition(4, 175).setSize(272, 15).setRange(0, 100).setGroup(options);
  sliders[si++] = cp5.addSlider("fillBrightness").setPosition(4, 194).setSize(272, 15).setRange(0, 5).setGroup(options);
  sliders[si++] = cp5.addSlider("differential").setPosition(4, 213).setSize(272, 15).setRange(0, 20).setValue(10).setGroup(options);
}

void style(String theControllerName) {
  Controller c = cp5.getController(theControllerName);
  c.getCaptionLabel().getStyle().setMarginTop(-15);
  c.getCaptionLabel().getStyle().setMarginLeft(19);
}