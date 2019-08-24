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
  
}
