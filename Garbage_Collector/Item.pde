class Item { 
  public int timeLeft = 900;
  public int x,y;
  public int chance = 1000; // The upper bound for the chance.  1million = 0.01% chance per second of spawning
  public int duration = 900; // duration = numSecs * 30
  public boolean inGame = true;
  public boolean inPlayer = false;
  public int w = 17;
  public int h = 17;
  
  public void initPos() {
    this.x = (int)random(0, width / 2);
    this.y = (int)random(0, height / 2);
  }
  
  public void chanceSpawn() {
    if (itemsInGame < 2 && !inGame) {
      int chance = (int)random(0, this.chance);
      if (chance < 3) {
        itemsInGame++;
        this.inGame = true;
        this.timeLeft = 900;
        this.x = (int)random(0, width / 2);
        this.y = (int)random(0, height / 2);
      }
    }
  }
  
  public void reset() {
    ;// Implement this one
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
   
   if (this.inPlayer) {
     if (this.duration == 0) {
        this.inPlayer = false;
        reset();
      } else {
        this.duration--;
      }
   }
  }
  
  public void checkCollision(int playerX, int playerY, int playerWidth, int playerHeight) {
    if(this.x+this.w > playerX && this.x < playerX+playerWidth && 
        this.y+this.h > playerY && this.y < playerY+playerHeight) {
      itemsInGame--;
      addEffects();
      this.inGame = false;
    }
  }
  
  public void addEffects() {
    ; // OVERRIDE THIS
  }
  
  
  public PImage getSkin() {
    return eyeImg;  // Override this class in children
  }
 
  /* renders player on the screen */
   public void render() {
     int section = map.getSectionByXY(this.x, this.y);
     image(this.getSkin(), map.translateX(section, x), map.translateY(section, y));
   }
  
}
