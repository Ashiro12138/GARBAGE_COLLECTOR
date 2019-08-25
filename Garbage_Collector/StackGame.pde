import processing.net.*;


class StackGame implements Game {
   
  Server s;
  Client c;
  
  int lastX, lastY, lastHealth;
  
  boolean stackGameStarted = false;
  
  public StackGame(PApplet app) {
    println("starting server...");
      
    
    s = new Server(app, 2310);
    
    while (c == null) {
      
      //println("busy waiting..");
      c = s.available();
    }
    
    println("client connected: " + c.ip());
    //handshake
    String hello = c.readString(); //readString() doesn't escape newline
    println(hello);
    if (!hello.equals("hello\n")) {
      println("client handshake failed");
      exit();
    }
    
    c.write("hello\n");
    delay(10);
    seed = (int)millis();
    randomSeed(seed);
    c.write(str(seed)+"\n");
    
    
   stackGameStarted = true;
   
    
  }
  
  /* network communication:
  - sets the pos for opponent
  pos,1,2
  
  - sets stolen var to 20
  collect,20
  
  - sets stashed var to 20
  stash,20
  
  - game over
  over
  
  */
  public void tick() {   
    
    if (stkBoi.x != lastX || stkBoi.y != lastY) {
      c.write("pos,"+stkBoi.x+","+stkBoi.y+"\n"); 
    }
    if (stkBoi.health !=  lastHealth) {
      c.write("health,"+stkBoi.health+"\n");
    }
    if (stkBoi.death) {
      c.write("overSTK");
    }
    if (ptrBoi.death) {
      c.write("overPTR");
    }
    
    stkBoi.render();
    lastX = stkBoi.x;
    lastY = stkBoi.y;
    lastHealth = stkBoi.health;
    
    
    //println("stkBoi section: " + map.getSectionByXY(stkBoi.x, stkBoi.y) + " ptrBoi section: " +  map.getSectionByXY(ptrBoi.x, ptrBoi.y));
    if (map.getSectionByXY(ptrBoi.x, ptrBoi.y) == map.getSectionByXY(stkBoi.x, stkBoi.y)) {
      ptrBoi.render();
    }
      
    if (s.available() == null) {
      return;
    }
    
    String line = c.readString();
    String[] datas = split(line, "\n");
    for (String new_data: datas){
      String[] data = split(new_data, ",");
      String cmd = data[0]; 
      if (cmd.equals("pos")) {
         ptrBoi.x = int(data[1]);
         ptrBoi.y = int(data[2]);
         println("ptr moved to: " , ptrBoi.x, ptrBoi.y);
      } else if (cmd.equals("collect")) {
          ptrBoi.collectCount = int(data[1]);
          println("collect " , ptrBoi.collectCount);
      } else if (cmd.equals("stash")) {
         ptrBoi.stashCount = int(data[1]); 
         println("stash" , ptrBoi.stashCount);
      } else if (cmd.equals("overPTR")) {
         //handle game over 
         ptrBoi.death = true;
         deathTimer = new Date();
      } else if (cmd.equals("overSTK")) {
         stkBoi.death = true;
         deathTimer = new Date();
      }
    }
  }
  
  
}
