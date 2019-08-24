class StackPlayer extends Player {
 //stk player should "stk up" as ptr stashes more thing
 //TODO: random spawn pos
 //x = 780;
 //y = 580;
 
 /*return the image that represents the current state of the stk
  *as it fills up it returns a more 'filled up' stage
  * TODO: handle the filling up
 */
 PImage getSkin() {
   return stkImg;
 }
 
 @Override
 void initPosition() {
   this.x = 100;
   this.y = 100;
 }
 
 //constructor
 public StackPlayer() {
   initPosition(); 
   speed = 8;
 }
 
 public void move(char direction) {
    switch (direction) {
      case 'd':
        moveX(speed);
        break;
      case 'a':
        moveX(-speed);
        break;
      case 'w':
        moveY(-speed);
        break;
      case 's':
        moveY(speed);
        break;
    }
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
  
  void render() {
         int section = map.getSectionByXY(this.x, this.y);
         image(this.getSkin(), map.translateX(section, x), map.translateY(section, y));
   }
}
