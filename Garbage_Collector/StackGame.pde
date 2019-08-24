import processing.net.*;


class StackGame implements Game {
   
  Server s;
  Client c;
  
  public StackGame(PApplet app) {
    println("starting server...");
    s = new Server(app, 2310);
    image(menuBg, -50, 0);
    image(serverWait, 90, -20, 800 * 0.8, 600 * 0.8);
    while (c == null) {
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
   
    
  }
  
  
  public void tick() {
    stkBoi.render();
  }
  
  
}
