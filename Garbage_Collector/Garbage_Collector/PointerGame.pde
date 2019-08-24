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
      String new_seed = c.readString().replace("\n",""); //readString() doesn't escape newline
      seed = int(new_seed);
      randomSeed(seed);
      
       
    }
  
    public void tick() {
      
     if (ptrBoi.x != lastX || ptrBoi.y != lastY) {
       println("pos,"+ptrBoi.x+","+ptrBoi.y+"\n");
       c.write("pos,"+ptrBoi.x+","+ptrBoi.y+"\n"); 
      }
    
    
      ptrBoi.render();
      
      lastX = ptrBoi.x;
      lastY = ptrBoi.y;
      
      //only render if they are in the same section
      if (map.getSectionByXY(stkBoi.x, stkBoi.y) == map.getSectionByXY(ptrBoi.x, ptrBoi.y)) {
        stkBoi.render();
      }
      
      if (c.available() <= 0) {
        return;
      }
      String line = c.readString();
      String[] data = split(line.replace("\n", ""), ",");
     
      String cmd = data[0]; 
      
      if (cmd.equals("pos")) {
         stkBoi.x = int(data[1]);
         stkBoi.y = int(data[2]);
         println("stkBoi moved to: " , stkBoi.x, stkBoi.y);

      } else if (cmd.equals("over")) {
         //handle game over 
      }
      
      
    }
  
}
