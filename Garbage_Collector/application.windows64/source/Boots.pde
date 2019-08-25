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
    this.duration = 600;
    stkBoi.setSpeed(9);
    this.inPlayer = true;
  }
  
  @Override
  public PImage getSkin() {
     return bootsImg;
  }
}
