import processing.net.*;

class PointerGame implements Game {
 
    Client c;
    
    boolean pointerGameStarted = false;
    int lastX, lastY, lastCollect, lastStash;
    
    public PointerGame(PApplet app) {
      
      c = new Client(app, "192.168.0.1", 2310);  //172.20.10.3
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
      Date now = new Date();
      if (now.getTime() - indicationTimer.getTime() < 5000) {
        image(ptrIndicator, ptrBoi.x, ptrBoi.y-31);
      }
      try {
        
        if (ptrBoi.x != lastX || ptrBoi.y != lastY) {
         println("pos,"+ptrBoi.x+","+ptrBoi.y+"\n");
         c.write("pos,"+ptrBoi.x+","+ptrBoi.y+"\n"); 
        }
        if (ptrBoi.collectCount != lastCollect) {
          println("collect,"+ptrBoi.collectCount);
          c.write("collect,"+ptrBoi.collectCount+"\n");
        }
        if (ptrBoi.stashCount != lastStash) {
          println("stash,"+ptrBoi.stashCount);
          c.write("stash,"+ptrBoi.stashCount+"\n");
          stkBoi.setSkin();
        }
        
        
        if (ptrBoi.death) {
          c.write("overPTR\n");
        }
      }
      catch (java.lang.NullPointerException e) {
        println("connection closed, game over");
        System.exit(1);
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
      
      try {
        
        String line = c.readString();
        String[] datas = split(line, "\n");
        for (String new_data: datas){
          String[] data = split(new_data, ",");
          String cmd = data[0]; 
        
          if (cmd.equals("pos")) {
             stkBoi.x = int(data[1]);
             stkBoi.y = int(data[2]);
             println("stkBoi moved to: " , stkBoi.x, stkBoi.y);
    
          } else if (cmd.equals("damageSelf")) {
             stkBoi.damageSelf = int(data[1]);
             stkBoi.setSkin();
             println("stkBoi damageSelf set to: ", stkBoi.damageSelf);
          } else if (cmd.equals("overSTK")) {
             //handle game over 
             stkBoi.death = true;
             deathTimer = new Date();
          } else if (cmd.equals("overPTR")) {
             ptrBoi.death = true;
             deathTimer = new Date();
          }
        }
      } catch (java.lang.NullPointerException e) {
         println("game over");
         System.exit(1);
      }
      
      
    }
  
}
