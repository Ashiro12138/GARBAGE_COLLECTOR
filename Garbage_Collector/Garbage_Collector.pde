// Pointer is client, stack player is server

import java.util.Date;

PImage ptrImg;  // Declare a variable of type PImage
PImage stkImg, stkHit1, stkHit2,stkHit3,stkHit4,stkHit5,stkHit6,stkHit7,stkHit8;
PImage menuBg, zoomGif;
PImage pointerOption, stackOption;
PImage serverWait;
int menuOption = 0; //0 is pointer, 1 is stack

int POINTER_AMOUNT = 100;

PFont font;

PointerPlayer ptrBoi;
StackPlayer stkBoi;
Map map;
Void papaVoid;
Pointer[] pointers = new Pointer[POINTER_AMOUNT];
Game game;

boolean gameStarted = false;
boolean zoomAnimationPlaying = false;
Date animationStart;

//screen size CANNOT be a variable, this is used for map translations
int SCREEN_X = 800;
int SCREEN_Y = 600;


void setup() {
  size(800, 600);
  ptrImg = loadImage("pointer_ai.png");
  stkImg = loadImage("stack_base.png");
  stkHit1 = loadImage("stack_hit1.png");
  stkHit2 = loadImage("stack_hit2.png"); 
  stkHit3 = loadImage("stack_hit3.png");
  stkHit4 = loadImage("stack_hit4.png");
  stkHit5 = loadImage("stack_hit5.png");
  stkHit6 = loadImage("stack_hit6.png");
  stkHit7 = loadImage("stack_hit7.png");
  stkHit8 = loadImage("stack_hit8.png");
  menuBg = loadImage("computer.png");
  font = createFont("COMIC.TTF", 24);
  textFont(font);
  zoomGif = loadImage("gameload.gif");
  pointerOption = loadImage("option_pointer.png");
  stackOption = loadImage("option_stack.png");
  serverWait = loadImage("server_wait.png");
  
  
  ptrBoi = new PointerPlayer();
  stkBoi = new StackPlayer();
  map = new Map();

  papaVoid = new Void(width, height);
  for (int i = 0; i < POINTER_AMOUNT; ++i) {
    pointers[i] = new Pointer();
  }

  frameRate(30);
  background(0);
}

/*
event call back that gets run once when a key is pressed.
TODO: prevent starvation as one player holds down a key
*/
void keyPressed() {
  
  if (!gameStarted) {
    if (keyCode == ENTER) {
      zoomAnimationPlaying = true;
      animationStart = new Date();
    }
    if (keyCode == UP) {
       menuOption = 0; 
    } else if (keyCode == DOWN) {
       menuOption = 1; 
    }
  }
  
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
     
    //println("ptrPos: " + ptrBoi.x + ":" + ptrBoi.y);
  }
    // stk movement (it's slower than ptr)
    key = Character.toLowerCase(key);
    switch(key) {
      case 'w':
        stkBoi.moveY(-8);
        break;
      case 's':
        stkBoi.moveY(8);
        break;
      case 'd':
        stkBoi.moveX(8);// += 8;
        break;
      case 'a':
        stkBoi.moveX(-8);// -= 8;  
        break;
    }
    
} 



void draw() {
  if (!gameStarted) {
    if (!zoomAnimationPlaying) {
      //draw main menu
      image(menuBg, -50, 0);
      if (menuOption == 0) {
        image(pointerOption, 90, -20, 800 * 0.8, 600 * 0.8);
      } else {
        image(stackOption, 90, -20, 800 * 0.8, 600 * 0.8);
      }

    }  else { //use time-variable busy waiting
      //image(zoomGif, -50,0);
      Date now = new Date();
      println(now.getTime() - animationStart.getTime());
      if (now.getTime() - animationStart.getTime() > 500) { //milliseconds time out to play animation
        gameStarted = true;
        if (menuOption == 0) { //pointer game
          game = new PointerGame(this);
        } else if (menuOption == 1) {
          image(menuBg, -50, 0);
          image(serverWait, 90, -20, 800 * 0.8, 600 * 0.8);
          game = new StackGame(this);
          
        }
      }
    }
    
  } else {
    background(0); //this is REDRAW
    int ptrSection = map.getSectionByXY(ptrBoi.x, ptrBoi.y);
    for (int i = 0; i < POINTER_AMOUNT; ++i) {
      ptrBoi.collectCount += pointers[i].collision(ptrBoi.x, ptrBoi.y, 17, 17);
      pointers[i].display(ptrSection);
    }
    papaVoid.display(ptrSection);
    // I know this should be in a class, will do later
    if (papaVoid.collision(ptrBoi.x, ptrBoi.y, 17, 17)) {
      ptrBoi.stashCount += ptrBoi.collectCount;
      ptrBoi.collectCount = 0;
      if (papaVoid.x < ptrBoi.x) {
        ptrBoi.canLeft = false;
      } else {
        ptrBoi.canRight = false;
      }
      
      if (papaVoid.y < ptrBoi.y) {
        ptrBoi.canUp = false;
      } else {
        ptrBoi.canDown = false;
      }
    } else {
      ptrBoi.freeMove();
    }
    ptrBoi.render();

    //stkBoi.move();
    text("Memory Stolen:", 10, 30);
    text(ptrBoi.collectCount, 195, 30);
    text("Memory Stashed:", 10, 60);
    text(ptrBoi.stashCount, 215, 60);
    
    //tick the game
    game.tick();

  }
}
