import hypermedia.video.*;

OpenCV opencv;

int ManagerWindowFrameWidth = 360; 
int ManagerWindowFrameHeight = 240; 

int ManagerWindowWidth = ManagerWindowFrameWidth * 2;
int ManagerWindowHeight = ManagerWindowFrameHeight * 3;

int DisplayWindowWidth = 800;
int DisplayWindowHeight = 600;
String PointsFileName = "points.txt";

Blob[] prev_blobs;

// window for Display voices
DisplayFrame fr;
DisplayApplet ap;
Boolean PointsExistFlag = false;

ArrayList corners;

Point origin;
Point OA, OB;

ArrayList shadows;

void setup() {
    size( ManagerWindowWidth, ManagerWindowHeight );
    fr = new DisplayFrame();

    println(ap);
    println(this);

    opencv = new OpenCV( this );
    opencv.capture( ManagerWindowFrameWidth, ManagerWindowFrameHeight );
    opencv.read();     // grab frame from camera
    opencv.remember();  // store the actual image in memory

    createFonts();

    resetPoints();

    readPointFile();

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
    ap.image(opencv.image(),0 ,0);

    displayAllPoints();

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

    displayShadowsManageWindow(blobtops, shadows);
    /*
      Display the result.
     */
    //    ap.image( opencv.image(), 0, 0);
}
