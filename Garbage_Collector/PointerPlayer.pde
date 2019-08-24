class PointerPlayer extends Player {
  int collectCount = 0; //amount of pointers collected
  int stashCount = 0; //amount of pointers stashed
  
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
  

  public void moveX(int x) {
    if (x > 0 && canRight || x < 0 && canLeft) {
      int newX = this.x + x;
      if (newX >= 0 && newX <= 1590) {
         this.x += x; 
      }
    }
  }
  
  public void moveY(int y) {
    if (y > 0 && canDown || y < 0 && canUp) {
      int newY = this.y + y;
      if (newY >= 0 && newY <= 1190) {
         this.y += y; 
      }
    }    
  }
  
  public void freeMove() {
    canLeft = true;
    canRight = true;
    canUp = true;
    canDown = true;
  }
}
