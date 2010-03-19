/* ----- setting ------ */
final int windowWidth = 800;
final int windowHeight = 600;
final int miniFrameSize = 100;
final int defaultBallonWidth = 400;
final int defaultBallonHeightLine = 32;
final int defaultBallonArc = 15;
final int ballonLimit = 10;
final color bgcolor = 0;
final int framerate = 10;
final int TTL = 30;
final int subTTL = 5;
final int soundSize = 256;
final int twitterSearchInterval = 30; // seconds
final String twitterPollingKeywordFile = "poll.txt";
final String twitterStreamingKeywordFile = "stream.txt";
/* -------------------- */




LogcafeCore g_core;
boolean[] keyState;
ArrayList tweets;
PFont[] fonts;
PFont defaultFont;
color[] colors;
int frame;
int mode;

// ----- for sound -----
import ddf.minim.*;
Minim minim;
AudioInput in;
// ---------------------

/*
// ----- for debug -----
PApplet root;
SetupFrame fr;
SetupApplet ap;
// ---------------------
*/

void setup(){
  //root = this;
  size(windowWidth, windowHeight);
  frameRate(30);
  frame = 0;
  mode = 0; // fuwa-mode

  // create fonts
  fonts = new PFont[6];
  for(int i=0; i<6; ++i){
    fonts[i] = createFont("Tahoma-Bold", 5+5*i);
  }
  defaultFont = createFont("Tahoma-Bold", 16);
  textFont(defaultFont);
  
  // create colors
  colors =   new color[6];
  colors[0] = color(255, 0, 0);
  colors[1] = color(0, 255, 0);
  colors[2] = color(0, 0, 255);
  colors[3] = color(255, 255, 0);
  colors[4] = color(255, 0, 255);
  colors[5] = color(0, 255, 255);
  
  // use sound
  minim = new Minim(this);
  //minim.debugOn();
  in = minim.getLineIn(Minim.STEREO, soundSize);
  
  // for key events
  keyState = new boolean[256];
  for(int i=0; i<256; ++i){
    keyState[i] = false;
  }

  // for setup applet
  //fr = new SetupFrame();
  
  // for logacfeCore
  g_core = new LogcafeCore(this);
  tweets = new ArrayList();
  
  FuwaTweet tw1 = new FuwaTweet("hello, world", "logcafe", "", "20100317112410");
  tweets.add(tw1);
  //FuwaTweet tw2 = new FuwaTweet("", "sokamura", "Sosuke Okamura", "20100317122222");
  //tweets.add(tw2);
}

float maxV=0.0;
void draw(){
  background(bgcolor);
  frame++;
  g_core.draw();
  g_core.update();
  if(frame == 10){
    frame = 0;
    FuwaTweet tw = (FuwaTweet)tweets.get(0);
    //println(tw.speed);
  }
  
  // draw the waveforms
  stroke(255);
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    line(windowWidth-soundSize + i, windowHeight-50 + (in.left.get(i)+in.right.get(i))*25, windowWidth-soundSize+1 + i, windowHeight-50 + (in.left.get(i+1)+in.right.get(i+1))*25);
  }
}

void keyPressed() {
    if (0<=key && key<256){
        keyState[key] = true;
    } else if(0<=keyCode && keyCode<256){
        keyState[keyCode] = true;
    }
}

void keyReleased() {
    if (0<=key && key<256){
        keyState[key] = false;
    } else if(0<=keyCode && keyCode<256) {
        keyState[keyCode] = false;
    }
}

