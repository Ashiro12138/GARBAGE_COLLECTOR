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
    this.duration = 15 * 30; 
    stkBoi.setSpeed(10);
    this.inPlayer = true;
  }
  
  @Override
  public PImage getSkin() {
     return bootsImg;
  }
}
