class Bomb extends Item {
  public Bomb() {
    this.chance = 100000;
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
