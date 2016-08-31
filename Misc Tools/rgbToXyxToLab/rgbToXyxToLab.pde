//formula from http://stackoverflow.com/questions/15408522/rgb-to-xyz-and-lab-colours-conversion

PImage img;

// user colour
float red;
float green;
float blue;

void setup() {
  img = loadImage("/Users/EAM/GitHub/Processing-Sketches/Grad School Sketches/colorReader/colortest/labtest2.jpg");
}

void draw() {
  float [] storeLABs = new float[3];
  float [] storeRGBs = new float[3];

  for (int i = 0; i < img.width; i++) {
    float [] lab = new float[3];
    for (int j = 0; j < img.height; j++) {
      color c = img.get(i, j);

      //split the color into its components
      red = c >> 16 & 0xFF;
      green = c >> 8 & 0xFF;
      blue = c & 0xFF;

      //convert the color to LAB
      lab = RGBtoLAB(red, green, blue);

      if (i % 100 == 0) {
        println("red: " + red + " " + "green: " + green + " " + "blue: " + blue);
        println("L: " + lab[0] + " " + "a: " + lab[1] + " " + " b: " + lab[2] + "\n");
      }

      //add each RGB component into a single number
      storeRGBs[0] += red;
      storeRGBs[1] += green;
      storeRGBs[2] += blue;

      //add each LAB component into a single number
      storeLABs[0] += lab[0];
      storeLABs[1] += lab[1];
      storeLABs[2] += lab[2];
    }
  }

  float resolution = img.width * img.height;

  storeRGBs[0] /= resolution;
  storeRGBs[1] /= resolution;
  storeRGBs[2] /= resolution;

  storeLABs[0] /= resolution;
  storeLABs[1] /= resolution;
  storeLABs[2] /= resolution;

  printArray(storeRGBs);
  printArray(storeLABs);
  exit();
}


float [] RGBtoLAB(float r, float g, float b)
{
  r /= 255.0;
  g /= 255.0;
  b /= 255.0;

  if (r > 0.04045) r = pow((r + 0.055) / 1.055, 2.4);
  else             r /= 12.92;
  if (g > 0.04045) g = pow((g + 0.055) / 1.055, 2.4);
  else             g /= 12.92;
  if (b > 0.04045) b = pow((b + 0.055) / 1.055, 2.4);
  else             b /= 12.92;

  r *= 100.0;
  g *= 100.0;
  b *= 100.0;

  //Observer = 2°, Illuminant = D65
  //float x = r * 0.4124 + g * 0.3576 + b * 0.1805;
  //float y = r * 0.2126 + g * 0.7152 + b * 0.0722;
  //float z = r * 0.0193 + g * 0.1192 + b * 0.9505;
  
  //Observer = 2°, Illuminant = D50
  float x = r * 0.4360747 + g * 0.3850649 + b * 0.1430804;
  float y = r * 0.2225045 + g * 0.7168786 + b * 0.0606169;
  float z = r * 0.0139322 + g * 0.0971045 + b * 0.7141733;

  //Observer = 2°, Illuminant = D65
  //float ref_X = 95.047;
  //float ref_Y = 100.000;
  //float ref_Z = 108.883;

  //Observer = 2°, Illuminant = D50
  float ref_X = 96.422;
  float ref_Y = 100.000;
  float ref_Z = 82.521;

  x /= ref_X;
  y /= ref_Y;
  z /= ref_Z;

  if (x > 0.008856) x = pow(x, 0.333333);
  else              x = (7.787 * x) + (16.0 / 116.0);
  if (y > 0.008856) y = pow(y, 0.333333);
  else              y = (7.787 * y) + (16.0 / 116.0);
  if (z > 0.008856) z = pow(z, 0.333333);
  else              z = (7.787 * z) + (16.0 / 116.0);

  float CIE_L = (116.0 * y) - 16.0;
  float CIE_a = 500.0 * (x - y);
  float CIE_b = 200.0 * (y - z);

  return new float[] {CIE_L, CIE_a, CIE_b};
}


float deltaE(float l1, float a1, float b1, float l2, float a2, float b2) {
  return sqrt(( (l1 - l2) * (l1 - l2) ) + ( (a1 - a2) * (a1 - a2) ) + ( (b1 - b2) * (b1 - b2) ));
}