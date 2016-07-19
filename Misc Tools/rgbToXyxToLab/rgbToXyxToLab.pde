//http://stackoverflow.com/questions/15408522/rgb-to-xyz-and-lab-colours-conversion

// user colour
int red   = 56;
int green = 79;
int blue  = 132;

void setup() {
  // user colour converted to XYZ space
  float [] xyz = RGBtoXYZ(red, green, blue);

  //target CIE-L*ab = 34.188, 8.072, -32.478
  float [] lab = XYZtoLAB(xyz[0], xyz[1], xyz[2]);

  printArray(xyz);
  printArray(lab);
  exit();
}


float [] RGBtoXYZ(int r, int g, int b)
{
  float var_R = r / 255.0;       //R from 0 to 255
  float var_G = g / 255.0;       //G from 0 to 255
  float var_B = b / 255.0;       //B from 0 to 255

  if (var_R > 0.04045) var_R = pow(( var_R + 0.055) / 1.055, 2.4);
  else                 var_R = var_R / 12.92;
  if (var_G > 0.04045) var_G = pow(( var_G + 0.055) / 1.055, 2.4);
  else                 var_G = var_G / 12.92;
  if (var_B > 0.04045) var_B = pow(( var_B + 0.055) / 1.055, 2.4);
  else                 var_B = var_B / 12.92;

  var_R *= 100.0;
  var_G *= 100.0;
  var_B *= 100.0;

  //Observer. = 2°, Illuminant = D65
  float x = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
  float y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
  float z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;

  float [] result = new float[] {x, y, z};
  return result;
}


float [] XYZtoLAB(float x, float y, float z)
{
  float ref_X =  95.047;      //Observer = 2°, Illuminant = D65
  float ref_Y = 100.000;
  float ref_Z = 108.883;

  float var_X = x / ref_X;
  float var_Y = y / ref_Y;
  float var_Z = z / ref_Z;

  println(var_X, var_Y, var_Z);

  if (var_X > 0.008856) var_X = pow(var_X, 0.333333);
  else                  var_X = (7.787 * var_X) + (16.0 / 116.0);
  if (var_Y > 0.008856) var_Y = pow(var_Y, 0.333333);
  else                  var_Y = (7.787 * var_Y) + (16.0 / 116.0);
  if (var_Z > 0.008856) var_Z = pow(var_Z, 0.333333);
  else                  var_Z = (7.787 * var_Z) + (16.0 / 116.0);

  println(var_X, var_Y, var_Z);

  float CIE_L = (116.0 * var_Y) - 16.0;
  float CIE_a = 500.0 * (var_X - var_Y);
  float CIE_b = 200.0 * (var_Y - var_Z);

  float [] result = new float[] {CIE_L, CIE_a, CIE_b};
  return result;
}