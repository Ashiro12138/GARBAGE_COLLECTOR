class Pointer{
  public int x, y;
  private int w = 17;
  private int h = 17;
  public boolean collected = false;
    
  Pointer() {
    this.x = (int)random(0, width * 2 - w);
    this.y = (int)random(0, height * 2 - h);

  }
  
  Pointer(int x, int y) {
    this.x = x;
    this.y = y;
  }
  

  public void display(int section) {
    //rect(x, y, w, h);
    if(!collected){
      image(ptrImg, map.translateX(section,x) , map.translateY(section, y)); 
    }
  }
  
  public boolean collision(int playerX, int playerY, int playerWidth, int playerHeight) {
    if(this.x+this.w > playerX && this.x < playerX+playerWidth && 
        this.y+this.h > playerY && this.y < playerY+playerHeight) {
      return true;
    }
    return false;
  }

  
  private void teleport() {
    this.x = (int)random(0, width);
    this.y = (int)random(0, height);
  }
  
  public void chanceMove() {
    float frequent = 1.0; // the percentage of chance to move per frame
    frequent /= 4.0;
    float chance = random(0, 100);
    if (chance < 25) {
      if (chance <= frequent)
        move(10, 0);
    } else if (chance < 50) {
      if (chance <= 25+frequent)
        move(-10, 0);
    } else if (chance < 75) {
      if (chance <= 50+frequent)
        move(0, 10);
    } else {
      if (chance <= 75+frequent)
        move(0, -10);
    }
  }
  
  private void move(int x, int y) {
    if(!collected){
      int newX = this.x + x;
      if (newX >= 0 && newX <= 1590) {
         this.x += x; 
      }
      int newY = this.y + y;
      if (newY >= 0 && newY <= 1190) {
         this.y += y; 
      }
    }
  }
}
