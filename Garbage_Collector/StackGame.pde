import processing.net.*;


class StackGame implements Game {
   
  Server s;
  Client c;
  
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
    
    if (!stackGameStarted) {
       return;
    }
    stkBoi.render();
    
    if (s.available() == null) {
      return;
    }
    
    String[] data = split(c.readString(), ",");
    String cmd = data[0]; 

    if (cmd.equals("pos")) {
       ptrBoi.x = int(data[1]);
       ptrBoi.y = int(data[2].trim());
       println("ptr moved to: " , ptrBoi.x, ptrBoi.y);
    } else if (cmd.equals("collect")) {
        ptrBoi.collectCount = int(data[1].trim());
        println("collect " , ptrBoi.collectCount);
    } else if (cmd.equals("stash")) {
       ptrBoi.stashCount = int(data[1].trim()); 
       println("stash" , ptrBoi.stashCount);
    } else if (cmd.equals("over")) {
       //handle game over 
    }
    ptrBoi.render();
  }
  
  
}
