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
