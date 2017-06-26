// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of the basics of motion with vector.
// A "Mover" object stores position, velocity, and acceleration as vectors
// The motion is controlled by affecting the acceleration (in this case towards the mouse)
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

float cX = 0;
float cY = 0;
float cW = 0;

Mover[] movers = new Mover[20];

void setup() {
  size(640,360);
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(); 
  }
}

void draw() {
  
  background(255);

  for (int i = 0; i < movers.length; i++) {
    movers[i].update(cX,cY);
    movers[i].display(cW); 
  }
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 println("received message");
    if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      //if(theOscMessage.checkTypetag("f")) {
        if(theOscMessage.get(0).floatValue() != 0){
          cX = theOscMessage.get(0).floatValue();
          cY = theOscMessage.get(1).floatValue();
          cW = theOscMessage.get(2).floatValue();
          println("received1");
          println("cX : "+cX);
          println("cY : "+cY);
          //println("cW : "+cW);
           //showMessage((int)f);
        }
      //}
    }
}