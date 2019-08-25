/* there are four 'sections' of the map, but only one window 
so we translate coordinates */
class Map {
  
  //give xy coordinate, return section of map
  /*
          |
    0     |   1
  --------|-------
    2     |   3 
          |
  
  */

  public int getSectionByXY(int x, int y) {

     if (x <= width && y <= height) {
       return 0;
     } else if (x > width && y < height) {
       return 1;
     } else if (x < width && y > height) {
       return 2;
     } else { //if (x > width && y > height) {
       return 3;
     }
  }
  
  /*
   * translate X coordinate of players into screen coordinates depending on section of map
   */

  public int translateX(int section, int x) {
     //int section = getSectionByXY(plx, player.y);
     //println("sec ", section);
     if (section % 2 == 1) { //if odd section (1 or 3), translate X, else do nothing
         return x - width;
     } else {
         return x;
     }
  }
   
  public int translateY(int section, int y) {
    //int section = getSectionByXY(player.x, player.y);
    //println("sec ", section);
     if (section > 1) { //translate Y for section 2 and 3 
       return y - height;
     } else {
       return y;
     }

  }

}
