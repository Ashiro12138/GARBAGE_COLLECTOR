class Eye extends Item { 
  public int timeLeft;
  public int duration;
  public int x,y;
  private boolean inGame;
  private int w;
  private int h;
  
  Eye() {
    this.timeLeft = 900;
    this.duration = 900;
    this.inGame = false;
    this.w = 17;
    this.h = 17;
  }
  
  public void chanceSpawn() {
    if (itemsInGame < 2 && !inGame) {
      int chance = (int)random(0, 1000000);
      if (chance < 3) {
        itemsInGame++;
        this.inGame = true;
        this.x = (int)random(0, width);
        this.y = (int)random(0, height);
      }
    }
  }
  public void update() {
    if (this.inGame) {
      if (timeLeft == 0) {
        this.inGame = false;
        itemsInGame--;
        
      } else {
        this.timeLeft--;
        render();
      }
    } else {
      chanceSpawn();
    }
  }
 
  public PImage getSkin() {
     return eyeImg;
  }
   
   /* renders player on the screen */
   public void render() {
     int section = map.getSectionByXY(this.x, this.y);
     image(this.getSkin(), map.translateX(section, x), map.translateY(section, y));
   }
   
   public int collision(int playerX, int playerY, int playerWidth, int playerHeight) {
    if(this.x+this.w > playerX && this.x < playerX+playerWidth && 
        this.y+this.h > playerY && this.y < playerY+playerHeight){
      
      return 1;
    }
    return 0;
  }
   
   
}  
  
