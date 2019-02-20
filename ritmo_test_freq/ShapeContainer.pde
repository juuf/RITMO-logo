// Load some shapes from files 
  
class ShapeContainer {
  PShape[] shapes;
  int shapeCount;
  int frame;
  
  ShapeContainer(String imagePrefix, int count) {
    shapeCount = count;
    shapes = new PShape[shapeCount];

    for (int i = 0; i < shapeCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 2) + ".svg";
      print(filename);
      shapes[i] = loadShape(filename);
    }
  }

//void display(float xpos, float ypos) {
//    frame = (frame+1) % shapeCount;
//    image(images[frame], xpos, ypos);
  }
  
//  int getWidth() {
//    return images[0].width;
//  }
//}
