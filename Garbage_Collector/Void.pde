
class Void{
  public int x, y;
  private int extent = 150;
  Void(int x, int y){
    this.x = x;
    this.y = y;
  }
   
  void display() {
    // TODO: Replace this with actual void picture
    circle(x, y, extent);
  }
}
