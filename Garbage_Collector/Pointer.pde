class Pointer{
  public int x, y;
  private int w = 17;
  private int h = 17;
  
  Pointer() {
    this.x = (int)random(0, width);
    this.y = (int)random(0, height);
  }
  
  Pointer(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void display() {
    rect(x, y, w, h);
  }
  
  public int collision(int playerX, int playerY, int playerWidth, int playerHeight) {
    if(this.x+this.w > playerX && this.x < playerX+playerWidth && 
        this.y+this.h > playerY && this.y < playerY+playerHeight){
      move();
      return 1;
    }
    return 0;
  }

  
  private void move() {
    this.x = (int)random(0, width);
    this.y = (int)random(0, height);
  }
}
