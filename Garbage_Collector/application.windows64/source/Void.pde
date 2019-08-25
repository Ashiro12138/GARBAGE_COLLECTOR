
class Void{
  public int x, y;
  private int extent = 300;
  private int radius = extent/2;
  private float radius_sqr = pow(radius, 2);
  Void(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public void display(int ptrSection) {
    // TODO: Replace this with actual void picture
    switch (ptrSection) {
      case 0:
        circle(width, height, extent);
        break;
      case 1:
        circle(0, height, extent);
        break;
      case 2:
        circle(width, 0, extent);
        break;
      case 3:
        circle(0, 0, extent);
        break;
    }
  }
  
  public boolean collision(int playerX, int playerY, int playerWidth, int playerHeight) {
    playerX += playerWidth/2;
    playerY += playerHeight/2;
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
    return (dist_sqr <= radius_sqr);
  }
}
