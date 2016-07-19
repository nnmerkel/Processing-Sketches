//http://stackoverflow.com/questions/15408522/rgb-to-xyz-and-lab-colours-conversion

// user colour
int red   = 56;
int green = 79;
int blue  = 132;

void setup() {
  // user colour converted to XYZ space
  float [] xyz = RGBtoXYZ(red, green, blue);

  float colX = xyz[0];
  float colY = xyz[1];
  float colZ = xyz[2];

  float [] lab = XYZtoLAB(colX, colY, colZ);

  printArray(xyz);
  printArray(lab);
  //target CIE-L*ab = 34.188, 8.072, -32.478
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

  var_R *= 100;
  var_G *= 100;
  var_B *= 100;

  //Observer. = 2°, Illuminant = D65
  float x = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
  float y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
  float z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;

  float [] result = new float[] {x, y, z};
  return result;
}


float [] XYZtoLAB(float x, float y, float z)
{
  float ref_X =  95.047;
  float ref_Y = 100.000;
  float ref_Z = 108.883;

  float var_X = x / ref_X;          //ref_X =  95.047   Observer= 2°, Illuminant= D65
  float var_Y = y / ref_Y;          //ref_Y = 100.000
  float var_Z = z / ref_Z;          //ref_Z = 108.883

  if (var_X > 0.008856) var_X = pow(var_X, (1/3));
  else                  var_X = (7.787 * var_X) + (16 / 116);
  if (var_Y > 0.008856) var_Y = pow(var_Y, (1/3));
  else                  var_Y = (7.787 * var_Y) + (16 / 116);
  if (var_Z > 0.008856) var_Z = pow(var_Z, (1/3));
  else                  var_Z = (7.787 * var_Z) + (16 / 116);

  float CIE_L = (116 * var_Y) - 16;
  float CIE_a = 500 * (var_X - var_Y);
  float CIE_b = 200 * (var_Y - var_Z);

  float [] result = new float[] {CIE_L, CIE_a, CIE_b};
  return result;
}