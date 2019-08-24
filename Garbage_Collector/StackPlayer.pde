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
   this.x = 750;
   this.y = 10;
 }
 
 //constructor
 public StackPlayer() {
   initPosition(); 
 }
}
