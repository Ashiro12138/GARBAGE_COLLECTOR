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
  
  public boolean collision(int playerX, int playerY, int playerWidth, int playerHeight) {
    for (int y = this.y; y <= this.y+this.h; ++y) {
      for(int x = this.x; x <= this.x+this.w; ++x) {
        if (x >= playerX && x <= playerX + playerWidth &&
            y >= playerY && y <= playerY + playerHeight) {
          move();
          return true;
        }
      }
    }
    return false;
  }

  
  private void move() {
    this.x = (int)random(0, width);
    this.y = (int)random(0, height);
  }
}
