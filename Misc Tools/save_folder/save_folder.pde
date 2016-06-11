import java.io.File;

void setup () {
  File f = new File("/Users/EAM/GitHub/Processing-Sketches/Misc Tools/save_folder/new");
  f.mkdirs();
  try {
    if (f.mkdirs()) { 
      System.out.println("Directory Created");
    } else {
      System.out.println("Directory is not created");
    }
  } 
  catch(Exception e) {
    e.printStackTrace();
  }
}