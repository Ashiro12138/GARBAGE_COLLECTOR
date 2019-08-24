class Eye extends Item {   
  public Eye() {
    this.chance = 1000;
  }
  @Override
  public void reset() {
    ptrBoi.changeImg(ptrImg);
  }
  
  @Override
  public void addEffects() {
    this.duration = 900;
    ptrBoi.changeImg(greenPtr);
    this.inPlayer = true;
  }
  
  @Override
  public PImage getSkin() {
     return eyeImg;
  }
   
   
}  
  
