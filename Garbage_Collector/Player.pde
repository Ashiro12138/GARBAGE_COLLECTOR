class Player {
   public int x,y;
   
   void initPosition() {
   }
   
<<<<<<< Updated upstream
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
  
   
=======
>>>>>>> Stashed changes
   PImage getSkin() {
     return ptrImg;
   }
   
   /* renders player on the screen */
<<<<<<< Updated upstream
   void render() {
         int section = map.getSectionByXY(this.x, this.y);
         image(this.getSkin(), map.translateX(section, x), map.translateY(section, y));
=======
   void move() {
      if (map.translateX(this) < 0 || map.translateY(this) < 0
          || map.translateX(this) > (800 * 2) || map.translateY(this) > (600 * 2)) {
       
       } else {
         image(this.getSkin(), map.translateX(this), map.translateY(this)); //mouseX, mouseY for mouse pos
       }
>>>>>>> Stashed changes
   }
   
   
}
