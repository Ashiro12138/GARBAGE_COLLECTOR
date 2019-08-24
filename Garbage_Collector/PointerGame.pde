import processing.net.*;

class PointerGame implements Game {
 
    Client c;
    
    boolean pointerGameStarted = false;
    int lastX, lastY, lastCollect, lastStash;
    
    public PointerGame(PApplet app) {
      
      c = new Client(app, "127.0.0.1", 2310); 
      c.write("hello\n"); //handshake
      
        
      while (c.available() <= 0) {
        //busy wait
      }
      String hello = c.readString(); //readString() doesn't escape newline
      println(hello);
      if (!hello.equals("hello\n")) {
        println("server handshake failed");
        println(hello);
        exit();
      }
      while (c.available() <= 0) {
        //busy wait
      }
      String seed = c.readString().trim(); //readString() doesn't escape newline
      randomSeed(int(seed));
      
       
    }
  
    public void tick() {
      
     if (ptrBoi.x != lastX || ptrBoi.y != lastY) {
       c.write("pos,"+ptrBoi.x+","+ptrBoi.y+"\n"); 
      }
      if (ptrBoi.collectCount != lastCollect) {
        c.write("collect,"+ptrBoi.collectCount+"\n");
      }
      if (ptrBoi.stashCount != lastStash) {
        c.write("stash,"+ptrBoi.stashCount+"\n");
      }
    
    
      ptrBoi.render();
      
      lastX = ptrBoi.x;
      lastY = ptrBoi.y;
      lastCollect = ptrBoi.collectCount;
      lastStash = ptrBoi.stashCount;
      
      //only render if they are in the same section
      if (map.getSectionByXY(stkBoi.x, stkBoi.y) == map.getSectionByXY(ptrBoi.x, ptrBoi.y)) {
        stkBoi.render();
      }
      
      if (c.available() <= 0) {
        return;
      }
      String[] data = split(c.readString(), ",");
     
      String cmd = data[0]; 
      
      if (cmd.equals("pos")) {
         stkBoi.x = int(data[1]);
         stkBoi.y = int(data[2].trim());
         println("stkBoi moved to: " , stkBoi.x, stkBoi.y);

      } else if (cmd.equals("over")) {
         //handle game over 
      }
      
      
    }
  
}
