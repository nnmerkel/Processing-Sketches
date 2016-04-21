class CircleString {
  String message = "01111010001010101000101";
  PFont f;
  float q = random(100, 200);

  CircleString () {
    f = createFont("Monaco", 40, true);
    // The text must be centered!
    textAlign(CENTER);
  }

  void display() {  

    // We must keep track of our position along the curve
    float arclength = 0;
    for (int i = 0; i < message.length (); i ++ ) {

      // The character and its width
      char currentChar = message.charAt(i);
      // Instead of a constant width, we check the width of each character.
      float w = textWidth(currentChar); 
      // Each box is centered so we move half the width
      arclength += w/2;

      // Angle in radians is the arclength divided by the radius
      // Starting on the left side of the circle by adding PI
      float theta = PI + arclength / (q/2);

      pushMatrix();

      // Polar to Cartesian conversion allows us to find the point along the curve. See Chapter 13 for a review of this concept.
      translate((q/2)*cos(theta), (q/2)*sin(theta)); 
      // Rotate the box (rotation is offset by 90 degrees)
      rotate(theta + PI/2); 

      // Display the character
      fill(0);
      text(currentChar, 0, 0);

      popMatrix();

      // Move halfway again
      arclength += w/2;
    }
  }
}

