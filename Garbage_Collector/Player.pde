class Player {
   public int x,y;
   public int maxSpeed;
   public int speed;
   
   void initPosition() {
   }
   
   public void moveX(int x) {
    int newX = this.x + x;
    if (newX >= 0 && newX <= 1590) {
       this.x += x; 
    }
  }
  
  public void moveY(int y) {
    int newY = this.y + y;
    if (newY >= 0 && newY <= 1190) {
       this.y += y; 
    }
  }
  
   
   PImage getSkin() {
     return ptrImg;
   }
   
   /* renders player on the screen */

   void render() {
         int section = map.getSectionByXY(this.x, this.y);
         image(this.getSkin(), map.translateX(section, x), map.translateY(section, y));
   }

   
   
}
