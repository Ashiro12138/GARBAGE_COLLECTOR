class Point {
  public int x;
  public int y;
  
  public Point() {  
  }
  
  public void newPoint() {
        this.x = (int)random(0, width / 2);
        this.y = (int)random(0, height / 2);
  }

}
