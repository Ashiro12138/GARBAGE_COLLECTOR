class Item { 
  public int timeLeft = 900;
  public int x,y;
  public int spawnTime = 30 * 30; // numSecs * 30
  public int timeToSpawn = 0;
  public int duration = 900; // duration = numSecs * 30
  public boolean inGame = false;
  public boolean inPlayer = false;
  public int w = 34;
  public int h = 34;
  
  public void initPos() {
    this.inGame = true;
    this.x = (int)random(0, width / 2);
    this.y = (int)random(0, height / 2);
  }
  
  public void chanceSpawn() {
    if (itemsInGame < 2 && !this.inGame) {
      if (this.timeToSpawn > this.spawnTime) {
        itemsInGame++;
        this.inGame = true;
        this.timeLeft = 900;
        this.x = points[pointPtr].x;
        this.y = points[pointPtr].y;
        this.timeToSpawn = 0;
        if (pointPtr == 99) {
          pointPtr = 0;
        } else {
          pointPtr++;
        }
      }
    }
  }
  
  //public boolean itemHere() {
  //  if(this.x+this.w > randPoint.x && this.x < randPoint.x+this.w && 
  //      this.y+this.h > randPoint.y && this.y < randPoint.y+this.w) {
  //    return true;
  //  }
  //  return false;
  //}
  
  public void reset() {
    ;// Implement this one
  }

  public void update() {
    if (!this.inGame) {
      this.timeToSpawn++;
    }
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
