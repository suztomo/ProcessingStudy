
import processing.net.*;
Server server;
int val = 0;

StringBuffer sb;
PFont font;

void setup(){
  size(200, 200);
  server = new Server(this, 11111);
  sb = new StringBuffer();
  font = createFont("Osaka", 30, true);
  textFont(font);
  println("suzuki ".matches("[a-zA-Z]+\\s+"));
}
String message = "";

int timerCount = 0;

void draw(){
  val = (val+1) % 255;
  background(val);
  Client c = server.available();
  if (c != null) {
    String msg = c.readString();
    println(msg);
    if (msg != null) {
      if (msg.matches("[a-zA-Z]+\\s+")) {
        sb.append(msg);
        message = sb.toString();
        sb = new StringBuffer();
      } else if (msg.matches("[a-zA-Z]+")) {
        sb.append(msg);
      } else {
        message = sb.toString();
        sb = new StringBuffer();
      }
    }
  }
  text(message, 15, 90);
}


