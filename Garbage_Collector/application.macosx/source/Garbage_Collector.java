import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Date; 
import processing.net.*; 
import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Garbage_Collector extends PApplet {

// Pointer is client, stack player is server



PImage ptrImg;  // Declare a variable of type PImage
PImage stkImg;
PImage ptrIndicator;
PImage menuBg;
PImage eyeImg;
PImage bombImg;
PImage bootsImg;
PImage heartImg;
PImage greenPtr;
PImage voidImg;
PImage pointerOption, stackOption;
PImage serverWait, enterIP;
int menuOption = 0; //0 is pointer, 1 is stack

int POINTER_AMOUNT = 100;

PFont font;
int seed;

PointerPlayer ptrBoi;
StackPlayer stkBoi;
Map map;
Void papaVoid;
Pointer[] pointers = new Pointer[POINTER_AMOUNT];
Game game;
Animation zoomGif;
Animation stkHit;
Animation stkDeath;
Animation ptrDeath;

// Power ups
int itemsInGame = 0;
int chances[] = new int[100];
int chancePtr = 0;
Point points[] = new Point[100];
int pointPtr = 0;
Eye eye;
Boots boots;
Bomb bomb;
Heart heart;


boolean gameStarted = false;
boolean zoomAnimationPlaying = false;
Date animationStart;
Date indicationTimer;
Date deathTimer;

//screen size CANNOT be a variable, this is used for map translations
int SCREEN_X = 2560;
int SCREEN_Y = 1600;


public void setup() {
  
  ptrImg = loadImage("pointer_ai.png");
  stkImg = loadImage("stack_base.png");
  ptrIndicator = loadImage("PlayerIndicator.png");
  greenPtr = loadImage("PowerUps/greenPointer.jpg");
  eyeImg = loadImage("PowerUps/Eye.jpg");
  bombImg = loadImage("PowerUps/Bomb.jpg");
  bootsImg = loadImage("PowerUps/Boots.jpg");
  heartImg = loadImage("PowerUps/Heart.jpg");
  voidImg = loadImage("The Void.jpg");
  
  menuBg = loadImage("computer.png");
  font = createFont("COMIC.TTF", 24);
  textFont(font);
  zoomGif = new Animation("MenuAnimation/menu_sprite", 53, "jpg");
  stkDeath = new Animation("StackDeath/stack_death", 15, "png");
  ptrDeath = new Animation("PointerDeath/pointer_death",6,"png");
  pointerOption = loadImage("option_pointer.png");
  stackOption = loadImage("option_stack.png");
  serverWait = loadImage("server_wait.png");
  enterIP = loadImage("enter_ip.png");
  
  ptrBoi = new PointerPlayer();
  stkBoi = new StackPlayer();
  map = new Map();
  
  //powerups
  eye = new Eye();
  boots = new Boots();
  heart = new Heart();
  bomb = new Bomb();  

  papaVoid = new Void(width, height);

  frameRate(30);
  background(0);
}

/*
event call back that gets run once when a key is pressed.
TODO: prevent starvation as one player holds down a key
*/
public void keyPressed() {
  
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
    if (keyCode == RIGHT || keyCode == LEFT || keyCode == UP || keyCode == DOWN) {
      if (menuOption == 1) {
        stkBoi.move(keyCode);
      } else {
         ptrBoi.move(keyCode);
      }
      
    }
  } else if (key == ' ' && menuOption == 1) {
    stkBoi.attackPointer();
  } else if(key == ' ') {
   ptrBoi.sacrificePointer(); 
  }
    
} 



public void draw() {
  if (!gameStarted) {
    if (!zoomAnimationPlaying) {
      //draw main menu
      image(menuBg, -50, 0);
      if (menuOption == 0) {
        image(pointerOption, 160, -20, 1280 * 0.7f, 800 * 0.7f);
      } else {
        image(stackOption, 160, -20, 1280 * 0.7f, 800 * 0.7f);
      }

    }  else { //use time-variable busy waiting
      zoomGif.display(0, 0, width, height);
      Date now = new Date();
      println(now.getTime() - animationStart.getTime());
      if (now.getTime() - animationStart.getTime() > 1500) { //milliseconds time out to play animation
        gameStarted = true;
        if (menuOption == 0) { //pointer game
          image(enterIP, 90, -20, 1280 * 0.8f, 800 * 0.8f); 
          game = new PointerGame(this);
          indicationTimer = new Date();
        } else if (menuOption == 1) {
          image(menuBg, -50, 0);
          image(serverWait, 90, -20, 1280 * 0.8f, 800 * 0.8f);
          game = new StackGame(this); 
        }
        for (int i = 0; i < POINTER_AMOUNT; ++i) {
          pointers[i] = new Pointer();
        }
        
        //eye.initPos();
        boots.initPos();
        //heart.initPos();
        bomb.initPos(); 
        
        for (int i = 0; i < 100; i++) {
          chances[i] = (int)random(0, 1000000);
          points[i] = new Point();
          points[i].newPoint();
        }
      }
    }
    
  } else {
    background(0); //this is REDRAW
    int ptrSection = map.getSectionByXY(ptrBoi.x, ptrBoi.y);
    int stkSection = map.getSectionByXY(stkBoi.x, stkBoi.y);
    if (menuOption==0){
      papaVoid.display(ptrSection);
    } else {
      papaVoid.display(stkSection);
    }
    for (int i = 0; i < POINTER_AMOUNT; ++i) {
      pointers[i].chanceMove();
      if(pointers[i].collision(ptrBoi.x, ptrBoi.y, 33, 34)){
        if(menuOption==0)
          ptrBoi.collectCount += 1;
        pointers[i].collected = true;
        pointers[i].x = -100;
        pointers[i].y = -100;
      } else {
        if (menuOption==0){
          pointers[i].display(ptrSection);
        } else {
          pointers[i].display(stkSection);
        }
      }
        
    }
    
    
    // I know this should be in a class, will do later
    if (papaVoid.collision(ptrBoi.x, ptrBoi.y, 33, 34)) {
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
  
    // Check Powerups 
    eye.update();
    eye.checkCollision(stkBoi.x,stkBoi.y, 33, 34);
    boots.update();
    boots.checkCollision(stkBoi.x,stkBoi.y, 33, 34);
    bomb.update();
    bomb.checkCollision(stkBoi.x,stkBoi.y, 34, 34);
    heart.update();
    heart.checkCollision(stkBoi.x,stkBoi.y, 33, 34);
    text("Memory Stolen:", 10, 30);
    text(ptrBoi.collectCount, 195, 30);
    text("Memory Stashed:", 10, 60);
    text(ptrBoi.stashCount, 215, 60);
    
    //tick the game
    game.tick();
  }
}
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

  public void display(float xpos, float ypos, int w, int h) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos, w, h);
  }
  
  public int getWidth() {
    return images[0].width;
  }
}
class Bomb extends Item {
  public Bomb() {
   this.spawnTime = 30 * 30;
  }
 
  @Override
  public void reset() {
    ;
  }
  
  @Override
  public void addEffects() {
    this.duration = 1;
    ptrBoi.collectCount = 0;
    this.inPlayer = true;
  }
  
  @Override
  public PImage getSkin() {
     return bombImg;
  }

}
class Boots extends Item {
  public Boots() {
    this.spawnTime = 40 * 30;
  }
  
  @Override
  public void reset() {
    stkBoi.setSpeed(8);
  }
  
  @Override
  public void addEffects() {
    this.duration = 600;
    stkBoi.setSpeed(9);
    this.inPlayer = true;
  }
  
  @Override
  public PImage getSkin() {
     return bootsImg;
  }
}
class Eye extends Item {   
  public Eye() {
    this.spawnTime = 50 * 30;
  }
  @Override
  public void reset() {
    ptrBoi.changeImg(ptrImg);
  }
  
  @Override
  public void addEffects() {
    this.duration = 900;
    ptrBoi.changeImg(greenPtr);
    this.inPlayer = true;
  }
  
  @Override
  public PImage getSkin() {
     return eyeImg;
  }
   
   
}  
  
interface Game {
  
  public void tick();
  
}
class Heart extends Item {
  public Heart() {
    this.spawnTime = 40 * 30;
  }
 
  @Override
  public void reset() {
    ;
  }
  
  @Override
  public void addEffects() {
    this.duration = 1;
    if (stkBoi.health <= 5) {
      stkBoi.health += 3;
    } else {
      stkBoi.health = 8;
    }
    stkBoi.setSkin();
    this.inPlayer = true;
  }
  
  @Override
  public PImage getSkin() {
     return heartImg;
  }

}
class Item { 
  public int timeLeft = 900;
  public int x,y;
  public int spawnTime = 30 * 30; // numSecs * 30
  public int timeToSpawn = 0;
  public int duration = 900; // duration = numSecs * 30
  public boolean inGame = false;
  public boolean inPlayer = false;
  public int w = 34;
  public int h = 34;
  
  public void initPos() {
    this.inGame = true;
    this.x = (int)random(0, width / 2);
    this.y = (int)random(0, height / 2);
  }
  
  public void chanceSpawn() {
    if (itemsInGame < 2 && !this.inGame) {
      if (this.timeToSpawn > this.spawnTime) {
        itemsInGame++;
        this.inGame = true;
        this.timeLeft = 900;
        this.x = points[pointPtr].x;
        this.y = points[pointPtr].y;
        this.timeToSpawn = 0;
        if (pointPtr == 99) {
          pointPtr = 0;
        } else {
          pointPtr++;
        }
      }
    }
  }
  
  //public boolean itemHere() {
  //  if(this.x+this.w > randPoint.x && this.x < randPoint.x+this.w && 
  //      this.y+this.h > randPoint.y && this.y < randPoint.y+this.w) {
  //    return true;
  //  }
  //  return false;
  //}
  
  public void reset() {
    ;// Implement this one
  }

  public void update() {
    if (!this.inGame) {
      this.timeToSpawn++;
    }
    if (this.inGame) {
      if (timeLeft == 0) {
        this.inGame = false;
        itemsInGame--;
      } else {
        this.timeLeft--;
        render();
      }
    } else {
      chanceSpawn();
    }
   
   if (this.inPlayer) {
     if (this.duration == 0) {
        this.inPlayer = false;
        reset();
      } else {
        this.duration--;
      }
   }
  }
  
  public void checkCollision(int playerX, int playerY, int playerWidth, int playerHeight) {
    if(this.x+this.w > playerX && this.x < playerX+playerWidth && 
        this.y+this.h > playerY && this.y < playerY+playerHeight) {
      itemsInGame--;
      addEffects();
      this.inGame = false;
    }
  }
  
  public void addEffects() {
    ; // OVERRIDE THIS
  }
  
  
  public PImage getSkin() {
    return eyeImg;  // Override this class in children
  }
 
  /* renders player on the screen */
   public void render() {
     int section = map.getSectionByXY(this.x, this.y);
     image(this.getSkin(), map.translateX(section, x), map.translateY(section, y));
   }
  
}
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

  public int getSectionByXY(int x, int y) {

     if (x <= width && y <= height) {
       return 0;
     } else if (x > width && y < height) {
       return 1;
     } else if (x < width && y > height) {
       return 2;
     } else { //if (x > width && y > height) {
       return 3;
     }
  }
  
  /*
   * translate X coordinate of players into screen coordinates depending on section of map
   */

  public int translateX(int section, int x) {
     //int section = getSectionByXY(plx, player.y);
     //println("sec ", section);
     if (section % 2 == 1) { //if odd section (1 or 3), translate X, else do nothing
         return x - width;
     } else {
         return x;
     }
  }
   
  public int translateY(int section, int y) {
    //int section = getSectionByXY(player.x, player.y);
    //println("sec ", section);
     if (section > 1) { //translate Y for section 2 and 3 
       return y - height;
     } else {
       return y;
     }

  }

}
class Player {
   public int x,y;
   public int maxSpeed;
   public int speed;
   private PImage playerImg = ptrImg;
   
   public void initPosition() {
   }
   
   public void moveX(int x) {
    int newX = this.x + x;
    if (newX >= 0 && newX <= width - 10) {
       this.x += x; 
    }
  }
  
  public void moveY(int y) {
    int newY = this.y + y;
    if (newY >= 0 && newY <= height - 10) {
       this.y += y; 
    }
  }
  
  public void changeImg(PImage newImg) {
    this.playerImg = newImg;
  }
   public PImage getSkin() {
     return this.playerImg;
   }
   
   /* renders player on the screen */

   public void render() {
         int section = map.getSectionByXY(this.x, this.y);
         image(this.getSkin(), map.translateX(section, x), map.translateY(section, y));
   }
   
   public void move(int direction) {
    switch (direction) {
      case RIGHT:
        moveX(speed);
        break;
      case LEFT:
        moveX(-speed);
        break;
      case UP:
        moveY(-speed);
        break;
      case DOWN:
        moveY(speed);
        break;
    }
  }

   
   
}
class Point {
  public int x;
  public int y;
  
  public Point() {  
  }
  
  public void newPoint() {
        this.x = (int)random(0, width / 2);
        this.y = (int)random(0, height / 2);
  }

}
class Pointer{
  public int x, y;
  private int w = 33;
  private int h = 34;
  public boolean collected = false;
    
  Pointer() {
    this.x = (int)random(0, width * 2 - w);
    this.y = (int)random(0, height * 2 - h);

  }
  
  Pointer(int x, int y) {
    this.x = x;
    this.y = y;
  }
  

  public void display(int section) {
    //rect(x, y, w, h);
    if(!collected){
      image(ptrImg, map.translateX(section,x) , map.translateY(section, y)); 
    }
  }
  
  public boolean collision(int playerX, int playerY, int playerWidth, int playerHeight) {
    if(this.x+this.w > playerX && this.x < playerX+playerWidth && 
        this.y+this.h > playerY && this.y < playerY+playerHeight) {
      return true;
    }
    return false;
  }

  
  private void teleport() {
    this.x = (int)random(0, width);
    this.y = (int)random(0, height);
  }
  
  public void chanceMove() {
    float frequent = 1.0f; // the percentage of chance to move per frame
    frequent /= 4.0f;
    float chance = random(0, 100);
    if (chance < 25) {
      if (chance <= frequent)
        move(10, 0);
    } else if (chance < 50) {
      if (chance <= 25+frequent)
        move(-10, 0);
    } else if (chance < 75) {
      if (chance <= 50+frequent)
        move(0, 10);
    } else {
      if (chance <= 75+frequent)
        move(0, -10);
    }
  }
  
  private void move(int x, int y) {
    if(!collected){
      int newX = this.x + x;
      if (newX >= 0 && newX <= 1590) {
         this.x += x; 
      }
      int newY = this.y + y;
      if (newY >= 0 && newY <= 1190) {
         this.y += y; 
      }
    }
  }
}


class PointerGame implements Game {
 
    Client c;
    
    boolean pointerGameStarted = false;
    int lastX, lastY, lastCollect, lastStash;
    
    public PointerGame(PApplet app) {
      
      c = new Client(app, "172.20.10.3", 2310); 
      c.write("hello\n"); //handshake
      
        
      while (c.available() <= 0) {
        //busy wait
      }
      String hello = c.readString(); //readString() doesn't escape newline
      println(hello);
      if (!hello.equals("hello\n")) {
        println("server handshake failed");
        println(hello);
        exit();
      }
      while (c.available() <= 0) {
        //busy wait
      }
      String new_seed = c.readString().replace("\n",""); //readString() doesn't escape newline
      seed = PApplet.parseInt(new_seed);
      randomSeed(seed);
      
       
    }
  
    public void tick() {
      Date now = new Date();
      if (now.getTime() - indicationTimer.getTime() < 5000) {
        image(ptrIndicator, ptrBoi.x, ptrBoi.y-31);
      }
      
      if (ptrBoi.x != lastX || ptrBoi.y != lastY) {
       println("pos,"+ptrBoi.x+","+ptrBoi.y+"\n");
       c.write("pos,"+ptrBoi.x+","+ptrBoi.y+"\n"); 
      }
      if (ptrBoi.collectCount != lastCollect) {
        println("collect,"+ptrBoi.collectCount);
        c.write("collect,"+ptrBoi.collectCount+"\n");
      }
      if (ptrBoi.stashCount != lastStash) {
        println("stash,"+ptrBoi.stashCount);
        c.write("stash,"+ptrBoi.stashCount+"\n");
        stkBoi.setSkin();
      }
      
      
      if (ptrBoi.death) {
        c.write("overPTR\n");
      }
    
    
      ptrBoi.render();
      
      lastX = ptrBoi.x;
      lastY = ptrBoi.y;
      lastCollect = ptrBoi.collectCount;
      lastStash = ptrBoi.stashCount;
      
      //only render if they are in the same section
      if (map.getSectionByXY(stkBoi.x, stkBoi.y) == map.getSectionByXY(ptrBoi.x, ptrBoi.y)) {
        stkBoi.render();
      }
      
      if (c.available() <= 0) {
        return;
      }
      String line = c.readString();
      String[] datas = split(line, "\n");
      for (String new_data: datas){
        String[] data = split(new_data, ",");
        String cmd = data[0]; 
      
        if (cmd.equals("pos")) {
           stkBoi.x = PApplet.parseInt(data[1]);
           stkBoi.y = PApplet.parseInt(data[2]);
           println("stkBoi moved to: " , stkBoi.x, stkBoi.y);
  
        } else if (cmd.equals("damageSelf")) {
           stkBoi.damageSelf = PApplet.parseInt(data[1]);
           stkBoi.setSkin();
           println("stkBoi damageSelf set to: ", stkBoi.damageSelf);
        } else if (cmd.equals("overSTK")) {
           //handle game over 
           stkBoi.death = true;
           deathTimer = new Date();
        } else if (cmd.equals("overPTR")) {
           ptrBoi.death = true;
           deathTimer = new Date();
        }
      }
      
      
    }
  
}
class PointerPlayer extends Player {
  int collectCount = 0; //amount of pointers collected
  int stashCount = 0; //amount of pointers stashed
  boolean death = false;
  
  boolean canLeft = true;
  boolean canRight = true;
  boolean canUp = true;
  boolean canDown = true;

  public void collectPointer() {
    collectCount++;
  }
  
  public void stashPointers() {
    stashCount += collectCount;
    collectCount = 0;
  }
  
  public @Override
  void initPosition() {
   x = 0;
   y = 0;
  }
   
  public PointerPlayer() {
      initPosition();
      maxSpeed = 10;
      speed = maxSpeed;
  }
  
  public void calcSpeed() {
    speed = maxSpeed - (int)(collectCount/2);
    speed = speed < 3 ? 3 : speed;
  }
   
  public void sacrificePointer() {
    if (collectCount > 0) {
      collectCount -= 1;
      calcSpeed();
    }  
  }
 
  @Override
  public void render() {
    if (!death) {
      int section = map.getSectionByXY(this.x, this.y);
      image(this.getSkin(), map.translateX(section, x), map.translateY(section, y));
    } else {
     Date now = new Date();
     if (now.getTime() - deathTimer.getTime() > 1400) {
       exit();
     }
     fill(0);
     rect(x, y, 33, 37);
     noFill();
     ptrDeath.display(x, y, 33, 37);
     delay(100);
     
   }
  }
 
  public void moveX(int x) {
    if (!death) {
      if (x > 0 && canRight || x < 0 && canLeft) {
        int newX = this.x + x;
        if (newX >= 0 && newX <= width*2 - 10) {
           this.x += x; 
        }
      }
    }
  }
  
  public void moveY(int y) {
    if (!death) {
      if (y > 0 && canDown || y < 0 && canUp) {
        int newY = this.y + y;
        if (newY >= 0 && newY <= height*2 - 10) {
           this.y += y; 
        }
      }
    }
  }
  
  public void freeMove() {
    canLeft = true;
    canRight = true;
    canUp = true;
    canDown = true;
  }
  
  public void die() {
   //Show Game Over and die
  }
}



class StackGame implements Game {
   
  Server s;
  Client c;
  
  int lastX, lastY, lastHealth, lastDamageSelf;
  
  boolean stackGameStarted = false;
  
  public StackGame(PApplet app) {
    println("starting server...");
      
    
    s = new Server(app, 2310);
    
    while (c == null) {
      
      //println("busy waiting..");
      c = s.available();
    }
    
    println("client connected: " + c.ip());
    //handshake
    String hello = c.readString(); //readString() doesn't escape newline
    println(hello);
    if (!hello.equals("hello\n")) {
      println("client handshake failed");
      exit();
    }
    
    c.write("hello\n");
    delay(10);
    seed = (int)millis();
    randomSeed(seed);
    c.write(str(seed)+"\n");
    
    
   stackGameStarted = true;
   
    
  }
  
  /* network communication:
  - sets the pos for opponent
  pos,1,2
  
  - sets stolen var to 20
  collect,20
  
  - sets stashed var to 20
  stash,20
  
  - game over
  over
  
  */
  public void tick() {   
    
    if (stkBoi.x != lastX || stkBoi.y != lastY) {
      c.write("pos,"+stkBoi.x+","+stkBoi.y+"\n"); 
    }
    if (stkBoi.health !=  lastHealth) {
      c.write("health,"+stkBoi.health+"\n");
    }
    if (stkBoi.damageSelf != lastDamageSelf) {
      println("damageSelf "+stkBoi.damageSelf+"\n");
      c.write("damageSelf,"+stkBoi.damageSelf+"\n");
    }
    if (stkBoi.death) {
      c.write("overSTK\n");
    }
    if (ptrBoi.death) {
      c.write("overPT\n");
    }
    
    stkBoi.render();
    lastX = stkBoi.x;
    lastY = stkBoi.y;
    lastHealth = stkBoi.health;
    lastDamageSelf = stkBoi.damageSelf;
    
    
    //println("stkBoi section: " + map.getSectionByXY(stkBoi.x, stkBoi.y) + " ptrBoi section: " +  map.getSectionByXY(ptrBoi.x, ptrBoi.y));
    if (map.getSectionByXY(ptrBoi.x, ptrBoi.y) == map.getSectionByXY(stkBoi.x, stkBoi.y)) {
      ptrBoi.render();
    }
      
    if (s.available() == null) {
      return;
    }
    
    String line = c.readString();
    String[] datas = split(line, "\n");
    for (String new_data: datas){
      String[] data = split(new_data, ",");
      String cmd = data[0]; 
      if (cmd.equals("pos")) {
         ptrBoi.x = PApplet.parseInt(data[1]);
         ptrBoi.y = PApplet.parseInt(data[2]);
         println("ptr moved to: " , ptrBoi.x, ptrBoi.y);
      } else if (cmd.equals("collect")) {
          ptrBoi.collectCount = PApplet.parseInt(data[1]);
          println("collect " , ptrBoi.collectCount);
      } else if (cmd.equals("stash")) {
         ptrBoi.stashCount = PApplet.parseInt(data[1]); 
         stkBoi.setSkin();
         println("stash", ptrBoi.stashCount);
      } else if (cmd.equals("overPTR")) {
         //handle game over 
         ptrBoi.death = true;
         deathTimer = new Date();
      } else if (cmd.equals("overSTK")) {
         stkBoi.death = true;
         deathTimer = new Date();
      }
    }
  }
  
  
}
class StackPlayer extends Player {
 //stk player should "stk up" as ptr stashes more thing
 //TODO: random spawn pos
 //x = 780;
 //y = 580;
 boolean death = false;
 int damageSelf = 0;
 int damageHeap = 0;
 
 /*return the image that represents the current state of the stk
  *as it fills up it returns a more 'filled up' stage
  * TODO: handle the filling up
 */
 int maxHealth = 8;
 int health = maxHealth;
 ArrayList<String> spriteList = new ArrayList();
 
 public PImage getSkin() {
   return stkImg;
 }
 
 public @Override
 void initPosition() {
   this.x = 750;
   this.y = 10;
 }
 
 //constructor
 public StackPlayer() {
   spriteList.add("stack_base.png");
   spriteList.add("stackHitAnimation/stack_hit1.png");
   spriteList.add("stackHitAnimation/stack_hit2.png");
   spriteList.add("stackHitAnimation/stack_hit3.png");
   spriteList.add("stackHitAnimation/stack_hit4.png");
   spriteList.add("stackHitAnimation/stack_hit5.png");
   spriteList.add("stackHitAnimation/stack_hit6.png");
   spriteList.add("stackHitAnimation/stack_hit7.png");
   spriteList.add("stackHitAnimation/stack_hit8.png");
   initPosition(); 
   speed = 8; 
 }
 
 public void moveX(int x) {
   if(!death){
      int newX = this.x + x;
      if (newX >= 0 && newX <= width*2 - 10) {
         this.x += x; 
      }
   }
  }
  
  public void moveY(int y) {
    if(!death){
      int newY = this.y + y;
      if (newY >= 0 && newY <= height*2 - 10) {
         this.y += y; 
      }    
    }
  }
  
  public void setSkin() {
    damageHeap = (int)(ptrBoi.stashCount / 5);
    health = maxHealth - (damageSelf + damageHeap);
    if (health < 0) {
      death = true;
      deathTimer = new Date();
    } else {
      //Check if the health is dead here
       stkImg = loadImage(spriteList.get(8-health));
    }
  }
  
  
  //TODO: need a stack death
  
  public void render() {
         if (!death){
           int section = map.getSectionByXY(this.x, this.y);
           image(this.getSkin(), map.translateX(section, x), map.translateY(section, y));
         } else {
           Date now = new Date();
           if (now.getTime() - deathTimer.getTime() > 1400) {
             exit();
           }
           fill(0);
           rect(x, y, 33, 37);
           noFill();
           stkDeath.display(x, y, 33, 37);
           delay(100);
           
         }
   }
   
   public int attackPointer() {
     if(this.x+33 > ptrBoi.x && this.x < ptrBoi.x+33 && 
        this.y+37 > ptrBoi.y && this.y < ptrBoi.y+37) {
       ptrBoi.death = true;
       deathTimer = new Date();
       return 1;
     }
     for (int i = 0; i < POINTER_AMOUNT; i++) {
          if(pointers[i].collision(this.x, this.y, 17, 17)) {
            damageSelf += 1;
            setSkin();
            println("you did oopsie");
            break;
          }
       }
      return 0;
     }
  public void setSpeed(int speed) {
    this.speed = speed;
  }
  
  public int getSpeed() {
    return this.speed;
  }
}

class Void{
  public int x, y;
  private int extent = 600;
  private int radius = extent/2;
  private float radius_sqr = pow(radius, 2);
  Void(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public void display(int ptrSection) {
    // TODO: Replace this with actual void picture
    switch (ptrSection) {
      case 0:
        image(voidImg, width-300, height-300);
        break;
      case 1:
        image(voidImg, -300, height-300);
        break;
      case 2:
        image(voidImg, width-300, -300);
        break;
      case 3:
        image(voidImg, -300, -300);
        break;
    }
  }
  
  public boolean collision(int playerX, int playerY, int playerWidth, int playerHeight) {
    playerX += playerWidth/2;
    playerY += playerHeight/2;
    int distX = abs(this.x - playerX);
    int distY = abs(this.y - playerY);
    if (distX > (playerWidth/2 + radius) ||
        distY > (playerHeight/2 + radius)) {
      return false;
    }
  
    if (distX <= playerWidth/2 || distY <= playerHeight/2) {
      return true;
    }
    
    float dist_sqr = pow(distX-playerWidth/2, 2) + pow(distY-playerHeight/2, 2);
    return (dist_sqr <= radius_sqr);
  }
}
  public void settings() {  size(1280, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Garbage_Collector" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
