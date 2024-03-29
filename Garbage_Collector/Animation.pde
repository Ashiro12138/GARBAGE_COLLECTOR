class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count, String end) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + (i+1) + "." + end;
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos, int w, int h) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos, w, h);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
