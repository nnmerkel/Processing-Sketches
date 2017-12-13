int guiWidth = 280;
int pad = 5;
int itemWidth = guiWidth-pad*2;
int itemHeight = 17;

void setupGUI() {
  cp5 = new ControlP5(this);
  ControlGroup options = cp5.addGroup("options").setPosition(pad, pad+10).setWidth(guiWidth).setBackgroundHeight(200).setLabel("Menu");
  ControlGroup shadows = cp5.addGroup("shadows").setPosition(pad, 200).setWidth(guiWidth).setBackgroundHeight(200).setLabel("Shadows");
  ControlGroup midtones = cp5.addGroup("midtones").setPosition(pad, 400).setWidth(guiWidth).setBackgroundHeight(200).setLabel("Midtones");
  ControlGroup highlights = cp5.addGroup("highlights").setPosition(pad, 600).setWidth(guiWidth).setBackgroundHeight(200).setLabel("Highlights");

  sliders = new Slider[20];
  ranges = new Range[10];
  toggles = new Toggle[10];

  int si = 0;
  int ri = 0;
  int ti = 0;

  sliders[si++] = cp5.addSlider("smallLimit").setPosition(0, pad).setSize(itemWidth, itemHeight).setRange(1, 300).setGroup(options);
  sliders[si++] = cp5.addSlider("total").setPosition(0, itemHeight+pad*2).setSize(itemWidth, itemHeight).setRange(1, 2000).setValue(100).setGroup(options);
  toggles[ti++] = cp5.addToggle("random").setPosition(0, itemHeight*2+pad*3).setSize(itemHeight, itemHeight).setGroup("options");
  toggles[ti++] = cp5.addToggle("orthogonal").setPosition(0, itemHeight*3+pad*4).setSize(itemHeight, itemHeight).setGroup("options");
  
  toggles[ti++] = cp5.addToggle("useShadows").setPosition(0, pad).setSize(itemHeight, itemHeight).setGroup(shadows);
  toggles[ti++] = cp5.addToggle("shadowFalseColor").setPosition(itemWidth/2, pad).setSize(itemHeight, itemHeight).setGroup(shadows);
  ranges[ri++] = cp5.addRange("shadowsRange", 0, 34, lowShadows, highShadows, 0, itemHeight+pad*2, itemWidth, itemHeight).setLowValue(1).setHighValue(15).setGroup(shadows);
  sliders[ri++] = cp5.addSlider("shadowHue").setRange(0, 360).setPosition(0, itemHeight*2+pad*3).setSize(itemWidth, itemHeight).setGroup(shadows);
  sliders[si++] = cp5.addSlider("shadowSaturationValue", 0, 100, 0, itemHeight*3+pad*4, itemWidth, itemHeight).setGroup(shadows);
  sliders[si++] = cp5.addSlider("shadowBrightnessValue", 0, 100, 0, itemHeight*4+pad*5, itemWidth, itemHeight).setGroup(shadows);
  sliders[si++] = cp5.addSlider("shadowLineSw").setPosition(0, itemHeight*5+pad*6).setSize(itemWidth, itemHeight).setRange(.5, 5.5).setNumberOfTickMarks(11).setGroup(shadows);
  sliders[si++] = cp5.addSlider("shadowPointSw").setPosition(0, itemHeight*6+pad*7).setSize(itemWidth, itemHeight).setRange(.5, 5.5).setNumberOfTickMarks(11).setGroup(shadows);
  
  toggles[ti++] = cp5.addToggle("useMidtones").setPosition(0, pad).setSize(itemHeight, itemHeight).setGroup(midtones);
  toggles[ti++] = cp5.addToggle("midtonesFalseColor").setPosition(itemWidth/2, pad).setSize(itemHeight, itemHeight).setGroup(midtones);
  ranges[ri++] = cp5.addRange("midtonesRange", 34, 67, lowMidtones, highMidtones, 0, itemHeight+pad*2, itemWidth, itemHeight).setLowValue(34).setHighValue(50).setGroup(midtones);
  sliders[ri++] = cp5.addSlider("midtonesHue").setRange(0, 360).setPosition(0, itemHeight*2+pad*3).setSize(itemWidth, itemHeight).setGroup(midtones);
  sliders[si++] = cp5.addSlider("midtonesSaturationValue", 0, 100, 0, itemHeight*3+pad*4, itemWidth, itemHeight).setGroup(midtones);
  sliders[si++] = cp5.addSlider("midtonesBrightnessValue", 0, 100, 0, itemHeight*4+pad*5, itemWidth, itemHeight).setGroup(midtones);
  sliders[si++] = cp5.addSlider("midtonesLineSw").setPosition(0, itemHeight*5+pad*6).setSize(itemWidth, itemHeight).setRange(.5, 3.5).setNumberOfTickMarks(7).setGroup(midtones);
  sliders[si++] = cp5.addSlider("midtonesPointSw").setPosition(0, itemHeight*6+pad*7).setSize(itemWidth, itemHeight).setRange(.5, 3.5).setNumberOfTickMarks(7).setGroup(midtones);
  
  toggles[ti++] = cp5.addToggle("useHighlights").setPosition(0, 4).setSize(itemHeight, itemHeight).setGroup(highlights);
  toggles[ti++] = cp5.addToggle("highlightsFalseColor").setPosition(0, 23).setSize(itemHeight, itemHeight).setGroup(highlights);
  ranges[ri++] = cp5.addRange("highlightsRange", 68, 100, lowHighlights, highHighlights, 0, 42, itemWidth, itemHeight).setLowValue(68).setHighValue(80).setGroup(highlights);
  sliders[ri++] = cp5.addSlider("highlightsHue").setRange(0, 360).setPosition(0, 61).setSize(itemWidth, itemHeight).setGroup(highlights);
  sliders[si++] = cp5.addSlider("highlightsSaturationValue", 0, 100, 0, 80, itemWidth, itemHeight).setGroup(highlights);
  sliders[si++] = cp5.addSlider("highlightsBrightnessValue", 0, 100, 0, 99, itemWidth, itemHeight).setGroup(highlights);
  sliders[si++] = cp5.addSlider("highlightsLineSw").setPosition(0, 118).setSize(itemWidth, itemHeight).setRange(.5, 3.5).setNumberOfTickMarks(7).setGroup(highlights);
  sliders[si++] = cp5.addSlider("highlightsPointSw").setPosition(0, 137).setSize(itemWidth, itemHeight).setRange(.5, 3.5).setNumberOfTickMarks(7).setGroup(highlights);
}