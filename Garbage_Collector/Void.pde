
class Void{
  public int x, y;
  private int extent = 150;
  Void(int x, int y){
    this.x = x;
    this.y = y;
  }
   
  public void display() {
    // TODO: Replace this with actual void picture
    circle(x, y, extent);
  }
  
  public boolean collision(int playerX, int playerY, int playerWidth, int playerHeight) {
    playerX += playerWidth/2;
    playerY += playerHeight/2;
    int radius = (int)(this.extent/2);
    int distX = abs(this.x - playerX);
    int distY = abs(this.y - playerY);
    if (distX > (playerWidth/2 + radius) ||
        distY > (playerHeight/2 + radius)) {
      return false;
    }
  
    if (distX <= playerWidth/2 || distY <= playerHeight/2) {
      return true;
    }
    
    float dist_sqr = pow(distX-playerWidth/2, 2) + pow(distY-playerHeight/2, 2);
    return (dist_sqr <= 5625.0); // 75^2 = 5625
  }
}
