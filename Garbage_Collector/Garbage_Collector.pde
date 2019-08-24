PImage ptrImg;  // Declare a variable of type PImage
PImage stkImg, stkHit1, stkHit2,stkHit3,stkHit4,stkHit5,stkHit6,stkHit7,stkHit8;

PointerPlayer ptrBoi;
StackPlayer stkBoi;
Map map;

//screen size CANNOT be a variable, this is used for map translations
int SCREEN_X = 800;
int SCREEN_Y = 600;

/* there are four 'sections' of the map, but only one window 
so we translate coordinates */
class Map {
  
  //give xy coordinate, return section of map
  /*
          |
    0     |   1
  --------|-------
    2     |   3 
          |
  
  */
  public int getPlayerSection(int x, int y) {
     if (x <= 800 && y <= 600) {
       return 0;
     } else if (x > 800 && y < 600) {
       return 1;
     } else if (x < 800 && y > 600) {
       return 2;
     } else { //if (x > 600 && y > 800) {
       return 3;
     }
  }
  
  /*
   * translate X coordinate of players into screen coordinates depending on section of map
   */
  public int translateX(Player player) {
     int section = getPlayerSection(player.x, player.y);
     //println("sec ", section);
     if (section % 2 == 1) { //if odd section (1 or 3), translate X, else do nothing
         return player.x - 800;
     } else {
         return player.x;
     }
  
  }
  
  public int translateY(Player player) {
    int section = getPlayerSection(player.x, player.y);
    //println("sec ", section);
     if (section > 1) { //translate Y for section 2 and 3 
       return player.y - 600;
     } else {
       return player.y;
     }
  }
  

}
  

class Player {
   public int x,y;
   
   void initPosition() {
   }
   
   PImage getSkin() {
     return ptrImg;
   }
   
   /* renders player on the screen */
   void move() {
      if (map.translateX(this) < 0 || map.translateY(this) < 0
          || map.translateX(this) > (800 * 2) || map.translateY(this) > (600 * 2)) {
       
       } else {
         image(this.getSkin(), map.translateX(this), map.translateY(this)); //mouseX, mouseY for mouse pos
       }
   }
   
   
}

class PointerPlayer extends Player {
  int collectCount = 0; //amount of pointers collected
  int stashCount = 0; //amount of pointers stashed

  void collectPointer() {
    collectCount++;
  }
  
  void stashPointers() {
    stashCount += collectCount;
    collectCount = 0;
  }
  
  @Override
  void initPosition() {
   x = 0;
   y = 0;
  }
   
  public PointerPlayer() {
      initPosition();
  }
  
}

  
class StackPlayer extends Player {
 //stk player should "stk up" as ptr stashes more thing
 //TODO: random spawn pos
 //x = 780;
 //y = 580;
 
 /*return the image that represents the current state of the stk
  *as it fills up it returns a more 'filled up' stage
  * TODO: handle the filling up
 */
 PImage getSkin() {
   return stkImg;
 }
 
 @Override
 void initPosition() {
   this.x = 780;
   this.y = 580;
 }
 
 //constructor
 public StackPlayer() {
   initPosition(); 
 }
}
  


void setup() {
  size(800, 600);
  ptrImg = loadImage("pointer_ai.png");
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
  map = new Map();
  
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
  //int ptrSection = map.getPlayerSection(ptrBoi.x, ptrBoi.y);
  //image(ptrImg, map.translateX(ptrBoi), map.translateY(ptrBoi)); //mouseX, mouseY for mouse pos
  //image(stkImg, stkBoi.x, stkBoi.y);
  ptrBoi.move();
  stkBoi.move();
  
  
}
