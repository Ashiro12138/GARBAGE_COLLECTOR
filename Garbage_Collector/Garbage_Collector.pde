PImage ptrImg;  // Declare a variable of type PImage
PImage stkImg, stkHit1, stkHit2,stkHit3,stkHit4,stkHit5,stkHit6,stkHit7,stkHit8;

PointerPlayer ptrBoi;
StackPlayer stkBoi;

class PointerPlayer {
  int collectCount = 0; //amount of pointers collected
  int stashCount = 0; //amount of pointers stashed
  public int x = 0;
  public int y = 0;
  
  
  void collectPointer() {
    collectCount++;
  }
  
  void stashPointers() {
    stashCount += collectCount;
    collectCount = 0;
  }
  
}
  
class StackPlayer {
 //stk player should "stk up" as ptr stashes more thing
 //TODO: random spawn pos
 public int x = 780;
 public int y = 580;
 
 /*return the image that represents the current state of the stk
  *as it fills up it returns a more 'filled up' stage
  * TODO: handle the filling up
 */
 PImage getSkin() {
   return stkImg;
 }
  
}
  


void setup() {
  size(800, 600);
  ptrImg = loadImage("Pointer Chan.png");
  stkImg = loadImage("stack_base.png");
  stkHit1 = loadImage("stack_base1.png");
  stkHit2 = loadImage("stack_base2.png"); 
  stkHit3 = loadImage("stack_base3.png");
  stkHit4 = loadImage("stack_base4.png");
  stkHit5 = loadImage("stack_base5.png");
  stkHit6 = loadImage("stack_base6.png");
  stkHit7 = loadImage("stack_base7.png");
  stkHit8 = loadImage("stack_base8.png");
  
  ptrBoi = new PointerPlayer();
  stkBoi = new StackPlayer();
  
  frameRate(30);
}

/*
event call back that gets run once when a key is pressed.
TODO: prevent starvation as one player holds down a key
*/
void keyPressed() {
  if (key == CODED) { 
      if (keyCode == LEFT) {
        ptrBoi.x -= 10;
      } else if (keyCode == RIGHT) {
        ptrBoi.x += 10;
      } else if (keyCode == UP) {
        ptrBoi.y -= 10;
      }
      else if (keyCode == DOWN) {
        ptrBoi.y += 10;
      }
      println("ptrPos: " + ptrBoi.x + ":" + ptrBoi.y);
  }
    // stk movement (it's slower than ptr)
    key = Character.toLowerCase(key);
    println(key);
    switch(key) {
      
      case 'w':
        stkBoi.y -= 8;
        break;
      case 's':
        stkBoi.y += 8;
        break;
      case 'd':
        stkBoi.x += 8;
        break;
      case 'a':
        stkBoi.x -= 8;  
        break;
    }
    
} 



void draw() {
  
  background(0);
  image(ptrImg, ptrBoi.x, ptrBoi.y); //mouseX, mouseY for mouse pos
  image(stkImg, stkBoi.x, stkBoi.y);
  
  
}
