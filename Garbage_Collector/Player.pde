class Player {
   public int x,y;
   
   void initPosition() {
   }
   
   PImage getSkin() {
     return ptrImg;
   }
   
   /* renders player on the screen */
   void move() {
      if (map.translateX(this) < 0 || map.translateY(this) < 0
          || map.translateX(this) > (800 * 2) || map.translateY(this) > (600 * 2)) {
       
       } else {
         image(this.getSkin(), map.translateX(this), map.translateY(this)); //mouseX, mouseY for mouse pos
       }
   }
   
   
}
