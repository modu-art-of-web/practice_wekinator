//This demo triggers a text display with each new message
// Works with 1 classifier output, any number of classes
//Listens on port 12000 for message /wek/outputs (defaults)

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;


//No need to edit:
PFont myFont, myBigFont;
int frameNum = 0;
int currentHue = 100;
int currentTextHue = 255;
String currentMessage = "";

class vec2 {
  float x, y;
};

vec2 pos = new vec2();
vec2 dpos = new vec2();

vec2 scl = new vec2();
vec2 dscl = new vec2();

float oldt = 0.0;
float nowt = 0.0;
boolean fillBack = false;
boolean isDrawLine = false;
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

ParticleSystem ps;
void setup() {
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  colorMode(HSB);
  size(400,400, P3D);
  smooth();
  background(255);
  
  String typeTag = "f";
  //myFont = loadFont("SansSerif-14.vlw");
  myFont = createFont("Arial", 14);
  myBigFont = createFont("Arial", 80);

  /**************donghyung**************/
  noStroke();
  fill(255,255,0);
  resetLineDefaults();
  nowt = millis() * 0.001;
  oldt = millis() * 0.001;

  /*****************particle system********************/
  ps = new ParticleSystem(new PVector(width/2,50));
}

void draw() {
  //frameRate(30);
  
  // if(isDrawLine){
  //   background(currentHue, 255, 255);
  //   fillBack = false;
  //   drawText();
  // }else{
  //   println("fillBack : "+fillBack);
  //   if(!fillBack){
  //     background(currentHue, 255, 255);
  //     fillBack = true;
  //     println("fill");
  //   };
  //   println("scl.x : "+scl.x);
  //   println("scl.y : "+scl.y);
  //   if(scl.x < 0.1 && scl.y < 0.1){
  //     resetLineDefaults();
  //   };
  //   // drawLineAni();
  // }

  // Option #1 (move the Particle System origin)
  ps.origin.set(mouseX,mouseY,0);

  // Option #2 (move the Particle System origin)
  // ps.addParticle(mouseX,mouseY);
  
  if(currentMessage.equals("1")){
    ps.addParticle();
  }else if(currentMessage.equals("2")){
    //background(255);
    fill(200,200,200);
  }else if(currentMessage.equals("3")){
    background(255);
  }  
  ps.run();
}

void resetLineDefaults(){
  /** object color */
  pos.x = width / 2;
  pos.y = height / 2;
  dpos.x = width / 2 + 100.0;
  dpos.y = height / 2 - 100.0;
  scl.x = 1.0;
  scl.y = 1.0;
  // dscl.x = 0.0;
  // dscl.y = 0.0;
  //ellipseMode(CENTER);
  //nowt = millis() * 0.001;
  //oldt = millis() * 0.001;
}
//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 println("received message");
    if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      if(theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      println("received1");
       showMessage((int)f);
      }
    }
}

void showMessage(int i) {
    currentHue = (int)generateColor(i);
    currentTextHue = (int)generateColor((i+1));
    currentMessage = Integer.toString(i);
    if(i > 1){
      isDrawLine = true;
    }else{
      isDrawLine = false;
    }
}

//Write instructions to screen.
void drawText() {
    stroke(0);
    textFont(myFont);
    textAlign(LEFT, TOP); 
    fill(currentTextHue, 255, 255);

    text("Receives 1 classifier output message from wekinator", 10, 10);
    text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
    
    textFont(myBigFont);
    text(currentMessage, 190, 180);
}

//Write instructions to screen.
void drawLineAni() {
  nowt = millis() * 0.01;
  float dt = nowt - oldt;
  oldt = nowt;
  
  pos.x += (dpos.x - pos.x) * dt * 0.5;
  pos.y += (dpos.y - pos.y) * dt * 0.1;
  
  scl.x += (dscl.x - scl.x) * dt * 0.1;
  scl.y += (dscl.y - scl.y) * dt * 0.1;
  
  translate(pos.x, pos.y);
  scale(scl.x, scl.y);
  
  ellipse(0, 0, 20, 20);   
}

float generateColor(int which) {
  float f = 100; 
  int i = which;
  if (i <= 0) {
     return 100;
  } 
  else {
     return (generateColor(which-1) + 1.61*255) %255; 
  }
}

// ParticleSystem ps;

// void setup() {
//   size(640,360);
//   ps = new ParticleSystem(new PVector(width/2,50));
// }

// void draw() {
//   background(255);
  
//   // Option #1 (move the Particle System origin)
//   ps.origin.set(mouseX,mouseY,0);
    
//   ps.addParticle();
//   ps.run();

//   // Option #2 (move the Particle System origin)
//   // ps.addParticle(mouseX,mouseY);

// }