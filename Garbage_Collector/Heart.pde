class Heart extends Item {
  public Heart() {
    this.chance = 10000;
  }
 
  @Override
  public void reset() {
    ;
  }
  
  @Override
  public void addEffects() {
    this.duration = 1;
    if (stkBoi.health <= 5) {
      stkBoi.health += 3;
    } else {
      stkBoi.health = 8;
    }
    stkBoi.setSkin();
    this.inPlayer = true;
  }
  
  @Override
  public PImage getSkin() {
     return heartImg;
  }

}
