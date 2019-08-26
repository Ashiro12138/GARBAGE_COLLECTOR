class PointerPlayer extends Player {
  int collectCount = 0; //amount of pointers collected
  int stashCount = 0; //amount of pointers stashed
  boolean death = false;
  
  boolean canLeft = true;
  boolean canRight = true;
  boolean canUp = true;
  boolean canDown = true;

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
