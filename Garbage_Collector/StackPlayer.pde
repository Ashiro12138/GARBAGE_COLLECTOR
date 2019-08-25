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
   spriteList.add("stackHitAnimation/Stack_hit1.png");
   spriteList.add("stackHitAnimation/Stack_hit2.png");
   spriteList.add("stackHitAnimation/Stack_hit3.png");
   spriteList.add("stackHitAnimation/Stack_hit4.png");
   spriteList.add("stackHitAnimation/Stack_hit5.png");
   spriteList.add("stackHitAnimation/Stack_hit6.png");
   spriteList.add("stackHitAnimation/Stack_hit7.png");
   spriteList.add("stackHitAnimation/Stack_hit8.png");
   initPosition(); 
   speed = 8; 
 }
 
 public void moveX(int x) {
   if(!death){
      int newX = this.x + x;
      if (newX >= 0 && newX <= 1590) {
         this.x += x; 
      }
   }
  }
  
  public void moveY(int y) {
    if(!death){
      int newY = this.y + y;
      if (newY >= 0 && newY <= 1190) {
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
  
  void render() {
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
  void setSpeed(int speed) {
    this.speed = speed;
  }
  
  int getSpeed() {
    return this.speed;
  }
}
