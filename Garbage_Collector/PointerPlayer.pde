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
