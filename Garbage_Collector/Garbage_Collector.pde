PImage ptrImg;  // Declare a variable of type PImage
PImage stkImg, stkHit1, stkHit2,stkHit3,stkHit4,stkHit5,stkHit6,stkHit7,stkHit8;

int POINTER_AMOUNT = 100;

PointerPlayer ptrBoi;
StackPlayer stkBoi;
Map map;
Void papaVoid;
Pointer[] pointers = new Pointer[POINTER_AMOUNT];

//screen size CANNOT be a variable, this is used for map translations
int SCREEN_X = 800;
int SCREEN_Y = 600;


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
  papaVoid = new Void(width/2, height/2);
  for (int i = 0; i < POINTER_AMOUNT; ++i) {
    pointers[i] = new Pointer();
  }
 
  frameRate(30);
}

/*
event call back that gets run once when a key is pressed.
TODO: prevent starvation as one player holds down a key
*/
void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      ptrBoi.moveX(10);
    } else if (keyCode == LEFT) {
      ptrBoi.moveX(-10);
    } else if (keyCode == UP) {
      ptrBoi.moveY(-10);
    } else if (keyCode == DOWN) {
      ptrBoi.moveY(10);
    }
     
    println("ptrPos: " + ptrBoi.x + ":" + ptrBoi.y);
  }
    // stk movement (it's slower than ptr)
    key = Character.toLowerCase(key);
    switch(key) {
      
      
      case 'w':
        if (ptrBoi.y - 10 >= 0) {
          stkBoi.y -= 8;
        }
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
  for (int i = 0; i < POINTER_AMOUNT; ++i) {
    pointers[i].collision(ptrBoi.x, ptrBoi.y, 17, 17);
    pointers[i].display();
  }
  papaVoid.display();
  ptrBoi.move();
  stkBoi.move();
   
}
