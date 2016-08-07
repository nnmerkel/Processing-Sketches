int guiWidth = 280;
int pad = 5;
int itemWidth = guiWidth-pad*2;
int itemHeight = 17;

void setupGUI() {
  colorMode(RGB, 255, 255, 255, 255);
  cp5 = new ControlP5(this);
  ControlGroup options = cp5.addGroup("options")
    .setPosition(pad, pad+10)
    .setWidth(guiWidth)
    .setBackgroundHeight(80)
    .setBackgroundColor(200)
    .setLabel("Menu");

  ControlGroup shadows = cp5.addGroup("shadows")
    .setPosition(pad, 120)
    .setWidth(guiWidth)
    .setBackgroundHeight(200)
    .setBackgroundColor(200)
    .setLabel("Shadows");

  ControlGroup midtones = cp5.addGroup("midtones")
    .setPosition(pad, 340)
    .setWidth(guiWidth)
    .setBackgroundHeight(200)
    .setBackgroundColor(200)
    .setLabel("Midtones");

  ControlGroup highlights = cp5.addGroup("highlights")
    .setPosition(pad, 560)
    .setWidth(guiWidth)
    .setBackgroundHeight(200)
    .setBackgroundColor(200)
    .setLabel("Highlights");


  sliders = new Slider[17];
  ranges = new Range[4];
  toggles = new Toggle[6];

  int si = 0;
  int ri = 0;
  int ti = 0;

  //first slider has si set to zero
  sliders[si] = cp5.addSlider("smallLimit")
    .setPosition(pad, pad)
    .setSize(itemWidth, itemHeight)
    .setRange(1, 300)
    .setGroup(options);

  sliders[si++] = cp5.addSlider("total")
    .setPosition(pad, itemHeight+pad*2)
    .setSize(itemWidth, itemHeight)
    .setRange(2, total).setValue(100)
    .setGroup(options);

  //first toggle is set to 0
  toggles[ti] = cp5.addToggle("darkBG")
    .setPosition(pad, itemHeight*2+pad*3)
    .setSize(itemHeight, itemHeight)
    .setGroup(options);

  style("darkBG", itemHeight+pad, -itemHeight);
  
  toggles[ti] = cp5.addToggle("lightBG")
    .setPosition(itemWidth/2, itemHeight*2+pad*3)
    .setSize(itemHeight, itemHeight)
    .setGroup(options);
    
    style("lightBG", itemHeight+pad, -itemHeight);

  //================================================ shadows group
  toggles[ti++] = cp5.addToggle("useShadows")
    .setPosition(pad, pad)
    .setSize(itemHeight, itemHeight)
    .setGroup(shadows);

  style("useShadows", itemHeight+pad, -itemHeight);

  toggles[ti++] = cp5.addToggle("shadowFalseColor")
    .setPosition(itemWidth/2, pad)
    .setSize(itemHeight, itemHeight)
    .setGroup(shadows);

  style("shadowFalseColor", itemHeight+pad, -itemHeight);

  //first range has ri set to zero
  ranges[ri] = cp5.addRange("shadowsRange")
    .setMin(lowShadows)
    .setMax(highShadows)
    .setPosition(pad, itemHeight+pad*2)
    .setSize(itemWidth, itemHeight)
    .setLowValue(10)
    .setHighValue(40)
    .setGroup(shadows);

  sliders[ri++] = cp5.addSlider("shadowHue")
    .setRange(0, 360)
    .setPosition(pad, itemHeight*2+pad*3)
    .setSize(itemWidth, itemHeight)
    .setGroup(shadows);

  sliders[si++] = cp5.addSlider("shadowSaturationValue")
    .setMin(0)
    .setMax(100)
    .setPosition(pad, itemHeight*3+pad*4)
    .setSize(itemWidth, itemHeight)
    .setGroup(shadows);

  sliders[si++] = cp5.addSlider("shadowBrightnessValue")
    .setMin(0)
    .setMax(100)
    .setPosition(pad, itemHeight*4+pad*5)
    .setSize(itemWidth, itemHeight)
    .setGroup(shadows);

  sliders[si++] = cp5.addSlider("shadowLineSw")
    .setPosition(pad, itemHeight*5+pad*6)
    .setSize(itemWidth, itemHeight)
    .setRange(.5, 3.5)
    .setNumberOfTickMarks(7)
    .setGroup(shadows);

  sliders[si++] = cp5.addSlider("shadowPointSw")
    .setPosition(pad, itemHeight*6+pad*7)
    .setSize(itemWidth, itemHeight)
    .setRange(.5, 3.5)
    .setNumberOfTickMarks(7)
    .setGroup(shadows);

  //=================================================== midtones group
  toggles[ti++] = cp5.addToggle("useMidtones")
    .setPosition(pad, pad)
    .setSize(itemHeight, itemHeight)
    .setGroup(midtones);

  style("useMidtones", itemHeight+pad, -itemHeight);

  toggles[ti++] = cp5.addToggle("midtonesFalseColor")
    .setPosition(itemWidth/2, pad)
    .setSize(itemHeight, itemHeight)
    .setGroup(midtones);

  style("midtonesFalseColor", itemHeight+pad, -itemHeight);

  ranges[ri++] = cp5.addRange("midtonesRange")
    .setMin(lowMidtones)
    .setMax(highMidtones)
    .setPosition(pad, itemHeight+pad*2)
    .setSize(itemWidth, itemHeight)
    .setLowValue(150)
    .setHighValue(180)
    .setGroup(midtones);

  sliders[ri++] = cp5.addSlider("midtonesHue")
    .setRange(0, 360)
    .setPosition(pad, itemHeight*2+pad*3)
    .setSize(itemWidth, itemHeight)
    .setGroup(midtones);

  sliders[si++] = cp5.addSlider("midtonesSaturationValue")
    .setMin(0)
    .setMax(100)
    .setPosition(pad, itemHeight*3+pad*4)
    .setSize(itemWidth, itemHeight)
    .setGroup(midtones);

  sliders[si++] = cp5.addSlider("midtonesBrightnessValue")
    .setMin(0)
    .setMax(100)
    .setPosition(pad, itemHeight*4+pad*5)
    .setSize(itemWidth, itemHeight)
    .setGroup(midtones);

  sliders[si++] = cp5.addSlider("midtonesLineSw")
    .setPosition(pad, itemHeight*5+pad*6)
    .setSize(itemWidth, itemHeight)
    .setRange(.5, 3.5)
    .setNumberOfTickMarks(7)
    .setGroup(midtones);

  sliders[si++] = cp5.addSlider("midtonesPointSw")
    .setPosition(pad, itemHeight*6+pad*7)
    .setSize(itemWidth, itemHeight)
    .setRange(.5, 3.5)
    .setNumberOfTickMarks(7)
    .setGroup(midtones);

  //========================================== highlights group
  toggles[ti++] = cp5.addToggle("useHighlights")
    .setPosition(pad, pad)
    .setSize(itemHeight, itemHeight)
    .setGroup(highlights);

  style("useHighlights", itemHeight+pad, -itemHeight);

  toggles[ti++] = cp5.addToggle("highlightsFalseColor")
    .setPosition(itemWidth/2, pad)
    .setSize(itemHeight, itemHeight)
    .setGroup(highlights);

  style("highlightsFalseColor", itemHeight+pad, -itemHeight);

  ranges[ri++] = cp5.addRange("highlightsRange")
    .setMin(lowHighlights)
    .setMax(highHighlights)
    .setPosition(pad, itemHeight+pad*2)
    .setSize(itemWidth, itemHeight)
    .setLowValue(220)
    .setHighValue(240)
    .setGroup(highlights);

  sliders[ri++] = cp5.addSlider("highlightsHue")
    .setRange(0, 360)
    .setPosition(pad, itemHeight*2+pad*3)
    .setSize(itemWidth, itemHeight)
    .setGroup(highlights);

  sliders[si++] = cp5.addSlider("highlightsSaturationValue")
    .setMin(0)
    .setMax(100)
    .setPosition(pad, itemHeight*3+pad*4)
    .setSize(itemWidth, itemHeight)
    .setGroup(highlights);

  sliders[si++] = cp5.addSlider("highlightsBrightnessValue")
    .setMin(0)
    .setMax(100)
    .setPosition(pad, itemHeight*4+pad*5)
    .setSize(itemWidth, itemHeight)
    .setGroup(highlights);

  sliders[si++] = cp5.addSlider("highlightsLineSw")
    .setPosition(pad, itemHeight*5+pad*6)
    .setSize(itemWidth, itemHeight)
    .setRange(.5, 3.5)
    .setNumberOfTickMarks(7)
    .setGroup(highlights);

  sliders[si++] = cp5.addSlider("highlightsPointSw")
    .setPosition(pad, itemHeight*6+pad*7)
    .setSize(itemWidth, itemHeight)
    .setRange(.5, 3.5)
    .setNumberOfTickMarks(7)
    .setGroup(highlights);
}


//move the labels around
void style(String theControllerName, int x, int y) {
  Controller c = cp5.getController(theControllerName);
  c.getCaptionLabel().getStyle().setMarginTop(y);
  c.getCaptionLabel().getStyle().setMarginLeft(x);
}