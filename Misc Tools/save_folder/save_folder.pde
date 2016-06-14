import java.io.File;

void setup () {
  setDestinationAlt();
}

void setDestination() {
  File f = new File("/Users/EAM/GitHub/Processing-Sketches/Misc Tools/save_folder/new2");
  f.mkdir();
  println(f.mkdir());
  try {
    if (f.mkdir()) { 
      System.out.println("Directory Created");
    } else {
      System.out.println("Directory is not created");
    }
  } 
  catch(Exception e) {
    e.printStackTrace();
  }
}

void setDestinationAlt() {
  String yup = "testFolder";
  File f = new File(sketchPath("" + yup));
  f.mkdir();
  try {
    if (f.mkdir()) { 
      System.out.println("Directory Created");
    } else {
      System.out.println("Directory is not created");
    }
  } 
  catch(Exception e) {
    e.printStackTrace();
  }
}