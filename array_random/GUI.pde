
void setupGUI() {
  cp5 = new ControlP5(this);
  ControlGroup options = cp5.addGroup("options").setPosition(10, 20).setWidth(280).setBackgroundHeight(200).setLabel("Menu");
  ControlGroup shadows = cp5.addGroup("shadows").setPosition(10, 200).setWidth(280).setBackgroundHeight(200).setLabel("Shadows");
  ControlGroup midtones = cp5.addGroup("midtones").setPosition(10, 400).setWidth(280).setBackgroundHeight(200).setLabel("Midtones");
  ControlGroup highlights = cp5.addGroup("highlights").setPosition(10, 600).setWidth(280).setBackgroundHeight(200).setLabel("Highlights");

  sliders = new Slider[20];
  ranges = new Range[10];
  toggles = new Toggle[10];

  int si = 0;
  int ri = 0;
  int ti = 0;

  sliders[si++] = cp5.addSlider("total").setPosition(0, 23).setSize(200, 15).setRange(100, 2000).setValue(100).setGroup(options);
  sliders[si++] = cp5.addSlider("smallLimit").setPosition(0, 4).setSize(200, 15).setRange(4, 300).setGroup(options);

  toggles[ti++] = cp5.addToggle("useShadows").setPosition(0, 4).setSize(15, 15).setGroup(shadows);
  toggles[ti++] = cp5.addToggle("shadowFalseColor").setPosition(0, 23).setSize(15, 15).setGroup(shadows);
  ranges[ri++] = cp5.addRange("shadowsRange", 0, 85, lowShadows, highShadows, 0, 42, 200, 15).setGroup(shadows);
  sliders[ri++] = cp5.addSlider("shadowHue").setRange(0, 360).setPosition(0, 61).setSize(200, 15).setGroup(shadows);
  sliders[si++] = cp5.addSlider("shadowSaturationValue", 0, 100, 0, 80, 200, 15).setGroup(shadows);
  sliders[si++] = cp5.addSlider("shadowBrightnessValue", 0, 100, 0, 99, 200, 15).setGroup(shadows);
  sliders[si++] = cp5.addSlider("shadowLineSw").setPosition(0, 118).setSize(200, 15).setRange(.5, 3.5).setNumberOfTickMarks(7).setGroup(shadows);
  sliders[si++] = cp5.addSlider("shadowPointSw").setPosition(0, 137).setSize(200, 15).setRange(.5, 3.5).setNumberOfTickMarks(7).setGroup(shadows);
  
  toggles[ti++] = cp5.addToggle("useMidtones").setPosition(0, 4).setSize(15, 15).setGroup(midtones);
  toggles[ti++] = cp5.addToggle("midtonesFalseColor").setPosition(0, 23).setSize(15, 15).setGroup(midtones);
  ranges[ri++] = cp5.addRange("midtonesRange", 86, 170, lowMidtones, highMidtones, 0, 42, 200, 15).setGroup(midtones);
  sliders[ri++] = cp5.addSlider("midtonesHue").setRange(0, 360).setPosition(0, 61).setSize(200, 15).setGroup(midtones);
  sliders[si++] = cp5.addSlider("midtonesSaturationValue", 0, 100, 0, 80, 200, 15).setGroup(midtones);
  sliders[si++] = cp5.addSlider("midtonesBrightnessValue", 0, 100, 0, 99, 200, 15).setGroup(midtones);
  sliders[si++] = cp5.addSlider("midtonesLineSw").setPosition(0, 118).setSize(200, 15).setRange(.5, 3.5).setNumberOfTickMarks(7).setGroup(midtones);
  sliders[si++] = cp5.addSlider("midtonesPointSw").setPosition(0, 137).setSize(200, 15).setRange(.5, 3.5).setNumberOfTickMarks(7).setGroup(midtones);
  
  toggles[ti++] = cp5.addToggle("useHighlights").setPosition(0, 4).setSize(15, 15).setGroup(highlights);
  toggles[ti++] = cp5.addToggle("highlightsFalseColor").setPosition(0, 23).setSize(15, 15).setGroup(highlights);
  ranges[ri++] = cp5.addRange("highlightsRange", 171, 255, lowHighlights, highHighlights, 0, 42, 200, 15).setGroup(highlights);
  sliders[ri++] = cp5.addSlider("highlightsHue").setRange(0, 360).setPosition(0, 61).setSize(200, 15).setGroup(highlights);
  sliders[si++] = cp5.addSlider("highlightsSaturationValue", 0, 100, 0, 80, 200, 15).setGroup(highlights);
  sliders[si++] = cp5.addSlider("highlightsBrightnessValue", 0, 100, 0, 99, 200, 15).setGroup(highlights);
  sliders[si++] = cp5.addSlider("highlightsLineSw").setPosition(0, 118).setSize(200, 15).setRange(.5, 3.5).setNumberOfTickMarks(7).setGroup(highlights);
  sliders[si++] = cp5.addSlider("highlightsPointSw").setPosition(0, 137).setSize(200, 15).setRange(.5, 3.5).setNumberOfTickMarks(7).setGroup(highlights);
  
  for (int i = 0; i < ti; i++) {
    toggles[i].captionLabel().style().padding(4, 3, 1, 3);
    toggles[i].captionLabel().style().marginTop = -19;
    toggles[i].captionLabel().style().marginLeft = 18;
    toggles[i].captionLabel().style().marginRight = 5;
    //toggles[i].captionLabel().setColorBackground(0x99ffffff);
  }
}

void drawGUI() {
  cp5.show();
  cp5.draw();
}

void updateColors(boolean stat) {
  ControllerGroup ctrl = cp5.getGroup("menu");

  for (int i = 0; i < sliders.length; i++) {
    if (sliders[i] == null) break;
    if (stat == false) {
      sliders[i].setColorLabel(color(50));
      sliders[i].captionLabel().setColorBackground(0x99ffffff);
    } else {
      sliders[i].setColorLabel(color(200));
      sliders[i].captionLabel().setColorBackground(0x99000000);
    }
  }
  for (int i = 0; i < ranges.length; i++) {
    if (ranges[i] == null) break;
    if (stat == false) {
      ranges[i].setColorLabel(color(50));
      ranges[i].captionLabel().setColorBackground(0x99ffffff);
    } else {
      ranges[i].setColorLabel(color(200));
      ranges[i].captionLabel().setColorBackground(0x99000000);
    }
  }
  for (int i = 0; i < toggles.length; i++) {
    if (toggles[i] == null) break;
    if (stat == false) {
      toggles[i].setColorLabel(color(50));
      toggles[i].captionLabel().setColorBackground(0x99ffffff);
    } else {
      toggles[i].setColorLabel(color(200));
      toggles[i].captionLabel().setColorBackground(0x99000000);
    }
  }
}

