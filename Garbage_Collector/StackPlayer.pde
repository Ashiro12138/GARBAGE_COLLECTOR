class StackPlayer extends Player {
 //stk player should "stk up" as ptr stashes more thing
 //TODO: random spawn pos
 //x = 780;
 //y = 580;
 
 /*return the image that represents the current state of the stk
  *as it fills up it returns a more 'filled up' stage
  * TODO: handle the filling up
 */
 int health = 8;
 ArrayList<String> spriteList = new ArrayList();
 
 PImage getSkin() {
   return stkImg;
 }
 
 @Override
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
    int newX = this.x + x;
    if (newX >= 0 && newX <= 1590) {
       this.x += x; 
    }
  }
  
  public void moveY(int y) {
    int newY = this.y + y;
    if (newY >= 0 && newY <= 1190) {
       this.y += y; 
    }    
  }
  
  public void setSkin() {
    if (health < 0) {
      die();
    }
    //Check if the health is dead here
     stkImg = loadImage(spriteList.get(8-health));
  }
  
  
  //TODO: need a stack death
  public void die() {
    
  }
  
  void render() {
         int section = map.getSectionByXY(this.x, this.y);
         image(this.getSkin(), map.translateX(section, x), map.translateY(section, y));
   }
   
   public int attackPointer() {
     int ptrx = ptrBoi.x;
     int ptry = ptrBoi.y;
     if (ptrx == this.x && ptry == this.y) {
       ptrBoi.die();
       return 1;
     }
     for (int i = 0; i < POINTER_AMOUNT; i++) {
          if(pointers[i].collision(this.x, this.y, 17, 17) == 1) {
            this.health--; 
            setSkin();
            println("you did oopsie");
            break;
          }
       }
      return 0;
     }
  void setSpeed(int speed) {
    this.speed = speed;
  }
  
  int getSpeed() {
    return this.speed;
  }
}
