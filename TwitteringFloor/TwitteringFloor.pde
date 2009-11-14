import twitter4j.org.json.*;
import twitter4j.*;
import twitter4j.http.*;
import twitter4j.examples.*;

import hypermedia.video.*;

OpenCV opencv;

int ManagerWindowFrameWidth = 360; 
int ManagerWindowFrameHeight = 240; 

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

Point origin;
Point OA, OB;

ArrayList shadows;

BackgroundTweets bgtweets;

void setup() {
    managerWindow = this;
    size( ManagerWindowWidth, ManagerWindowHeight );

    println(ap);
    println(this);

    opencv = new OpenCV( this );
    opencv.capture( ManagerWindowFrameWidth, ManagerWindowFrameHeight, 0);
    opencv.read();     // grab frame from camera
    opencv.remember();  // store the actual image in memory

    createFonts();

    resetPoints();

    readPointFile();

    fr = new DisplayFrame();

    shadows = new ArrayList();
}


void draw() {
    fill(255, 255, 255);
    rect(0, 0, ManagerWindowWidth, ManagerWindowHeight);


    opencv.read();     // grab frame from camera

    /*
      show the original image
      ■□
      □□
      □□
     */
    image( opencv.image(), 0, 0);


    displayAllCorners();

    /*
      display the image in memory on the right
      □■
      □□
      □□
     */
    image(opencv.image(OpenCV.MEMORY), ManagerWindowFrameWidth, 0);

    // make the difference between the current image and the image in memory
    opencv.absDiff();

    /*
      display the difference
      □□
      ■□
      □□
     */
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
    image( opencv.image(), ManagerWindowFrameWidth, ManagerWindowFrameHeight );


    /*
      display the distorted image with blobs
      □□
      □□
      ■□
     */
    opencv.convert(OpenCV.GRAY);
    opencv.threshold(32);
    image( opencv.image(), 0, ManagerWindowFrameHeight * 2);
    Blob[] blobs = opencv.blobs( 1200, ManagerWindowFrameWidth * ManagerWindowFrameHeight/2, 5,
                                 false, OpenCV.MAX_VERTICES*4 );
    prev_blobs = blobs;
    Point[] blobtops = blobTops(blobs);
    displayBlobs(blobs, 0, ManagerWindowFrameHeight*2);


    updateShadowsByBlobtops(blobtops);
    //displayShadowsManageWindow(blobtops, shadows);
    /*
      Display the result.
     */
    opencv.restore();
    //    ap.image( opencv.image(), 0, 0);
    //    ap.redraw();
}
