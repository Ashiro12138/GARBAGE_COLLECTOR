class Boots extends Item {
  public Boots() {
    this.chance = 10000;
  }
  
  @Override
  public void reset() {
    stkBoi.setSpeed(8);
  }
  
  @Override
  public void addEffects() {
    this.duration = 600;
    stkBoi.setSpeed(10);
    this.inPlayer = true;
  }
  
  @Override
  public PImage getSkin() {
     return bootsImg;
  }
}
