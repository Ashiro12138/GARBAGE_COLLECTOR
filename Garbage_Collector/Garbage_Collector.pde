PImage img;  // Declare a variable of type PImage

int x = 0;
int y = 0;

void setup() {
  size(800, 600);
  img = loadImage("Pointer Chan.png");
  frameRate(30);
}

/*
event call back that gets run once when a key is pressed.
*/
void keyPressed() {
  if (key == CODED) { 
    if (keyCode == LEFT) {
      x -= 10;
    } else if (keyCode == RIGHT) {
      x += 10;
    } else if (keyCode == UP) {
      y -= 10;
    }
      else if (keyCode == DOWN) {
        y += 10;
    }
  } 
}


void draw() {
  
  background(0);
  image(img, x, y); //mouseX, mouseY for mouse pos
  
  
  
}
