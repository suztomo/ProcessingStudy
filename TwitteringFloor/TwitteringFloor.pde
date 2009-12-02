import twitter4j.org.json.*;
import twitter4j.*;
import twitter4j.http.*;
import twitter4j.examples.*;

import hypermedia.video.*;


OpenCV opencv;

int ManagerWindowFrameWidth = 300; 
int ManagerWindowFrameHeight = 225;

int ManagerWindowWidth = ManagerWindowFrameWidth * 2;
int ManagerWindowHeight = ManagerWindowFrameHeight * 3;

int DisplayWindowWidth = 1024;
int DisplayWindowHeight = 768;
String PointsFileName = "points.txt";

Blob[] prev_blobs;

// window for Display voices
DisplayFrame fr;
DisplayApplet ap;

PApplet managerWindow;
Boolean PointsExistFlag = false;

ArrayList corners;

ArrayList belowMessages;

Point origin;
Point OA, OB;

ArrayList shadows;

BackgroundTweets bgtweets;
BackgroundForces bgforces;
int bgforceUpdateInterval;

int SUCCESS = 0;
int ERROR = -1;

/*
  If NODEBUG, the main screen is used to display.
*/
Boolean NODEBUG = true;


void setup() {
    managerWindow = this;
    size( ManagerWindowWidth, ManagerWindowHeight );

    delay(1000);
    opencv = new OpenCV( this );
    opencv.capture( ManagerWindowFrameWidth, ManagerWindowFrameHeight, 0);

    createFonts();
    resetPoints();

    
    readPointFile();

    /*
      To reset PointExistFlag, delete points.txt
    */
    if (PointsExistFlag && NODEBUG) {
      size(DisplayWindowWidth, DisplayWindowHeight);
    } else {
      NODEBUG = false;
    }
    
    if (NODEBUG) {
      bgtweets = new BackgroundTweets(managerWindow);
    } else {
      fr = new DisplayFrame();    
    }
    bgforces = new BackgroundForces();
    bgforceUpdateInterval = DisplayWindowFrameRate * 5; // update each 3 seconds.

    shadows = new ArrayList();
    
    vfactory = new VoiceGenerator("messages");

    PFont font;
    PFont fontCaption;
    if (NODEBUG) {
        background(0xFF);
        try {
            font = (PFont)(FontsBySize[2].get(2));
            fontCaption = createFont("Osaka-UI", 50);
        } catch(Exception e) {
            fontCaption = font = createFont("Osaka-UI", 40);
        }
        fill(0x77);
        textFont(fontCaption);
        text("あしもとをみて", 330, 300);
        textFont(font);
        fill(0xCC);
        text("起動中です。プロジェクタ投影面に人や影がいないようにしてください。", 70, 420);
    }
    belowMessages = new ArrayList();
    readBelowMessages();
}

void readBelowMessages() {
  belowMessages.add("あしもとをみて  /  岡村聡介 鈴木友博");
  belowMessages.add("ここではきものを脱いでお上がりください。");
  belowMessages.add("iii Exhibition 11  - 夢 見ていますか？");
}

void draw() {
    if (NODEBUG) {
        if (frameCount == 1) {
            delay(1000 * 3);
            fill(0xFF);
            rect(0, 0, DisplayWindowWidth, DisplayWindowHeight);
            drawFrame(managerWindow);
            return;   
        } else if (frameCount == 2) {
            delay(1000);
            opencv.read();     // grab frame from camera
            opencv.remember();  // store the actual image in memory
            return;
        }
    }
    fill(0xFF);
    if (NODEBUG) {
      rect(0, 0, DisplayWindowWidth, DisplayWindowHeight);
    } else {
      rect(0, 0, ManagerWindowWidth, ManagerWindowHeight);
    }


    opencv.read();     // grab frame from camera

    /*
      show the original image
      ■□
      □□
      □□
     */
     if (!NODEBUG)
       image( opencv.image(), 0, 0);

     if (!NODEBUG)
       displayAllCorners();

    /*
      display the image in memory on the right
      □■
      □□
      □□
     */
    if (!NODEBUG)
      image(opencv.image(OpenCV.MEMORY), ManagerWindowFrameWidth, 0);

    // make the difference between the current image and the image in memory
    opencv.absDiff();

    /*
      display the difference
      □□
      ■□
      □□
     */
    if (!NODEBUG)
      image( opencv.image(), 0, ManagerWindowFrameHeight );

    if (!PointsExistFlag) {
        // return if there is no calibration points.
        return;
    }

    PImage captureImage = opencv.image();
    PImage maskImage = createDistortedImage(captureImage);
    opencv.copy(maskImage);
    /*
      display the distorted image
      □□
      □■
      □□
     */
     if (!NODEBUG)
       image( opencv.image(), ManagerWindowFrameWidth, ManagerWindowFrameHeight );


    /*
      display the distorted image with blobs
      □□
      □□
      ■□
     */
    opencv.convert(OpenCV.GRAY);
    opencv.threshold(16);
    if (!NODEBUG)
      image( opencv.image(), 0, ManagerWindowFrameHeight * 2);
    
    /*
      To detect small shadow, change the first minBlobs parameter in this function.
    */
    Blob[] blobs = opencv.blobs( 2400, ManagerWindowFrameWidth * ManagerWindowFrameHeight/2, 5,
                                 false, OpenCV.MAX_VERTICES*4 );
    prev_blobs = blobs;
    Point[] blobtops = blobTops(blobs);
    if (!NODEBUG)
       displayBlobs(blobs, 0, ManagerWindowFrameHeight*2);

    updateShadowsByBlobtops(blobtops);
    //displayShadowsManageWindow(blobtops, shadows);
    /*
      Display the result.
     */
 //   opencv.restore();
    //    ap.image( opencv.image(), 0, 0);
    //    ap.redraw();
    if (NODEBUG) {
        updateBackground();
        updateVoices();
    }
    
    if (frameCount % bgforceUpdateInterval == 0) {
      bgforces.update();
    }
//    bgforces.draw();
    
    if (NODEBUG) {
      drawFrame(managerWindow);
    }
}
