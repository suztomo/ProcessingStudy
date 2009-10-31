import hypermedia.video.*;


OpenCV opencv;

int ManagerWindowFrameWidth = 360; 
int ManagerWindowFrameHeight = 240; 

int ManagerWindowWidth = ManagerWindowFrameWidth * 2;
int ManagerWindowHeight = ManagerWindowFrameHeight * 3;

int DisplayWindowWidth = 800;
int DisplayWindowHeight = 600;
String PointsFileName = "points.txt";


// window for Debug
DebugFrame fr;
DebugApplet ap;
Boolean PointsExistFlag = false;

//Point[] corners;
ArrayList corners;
//int cornersSize = 0;

Point origin;
Point OA, OB;

ArrayList shadows;

void setup() {
    size( ManagerWindowWidth, ManagerWindowHeight );
    fr = new DebugFrame();

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


    opencv.read();                               // grab frame from camera
    image( opencv.image(), 0, 0);                // show the original image
    ap.image(opencv.image(),0 ,0);

    displayAllPoints();
    // make the difference between the current image and the image in memory
    image(opencv.image(OpenCV.MEMORY), ManagerWindowFrameWidth, 0);

    // Caribrated image
    opencv.absDiff();
    // display the image in memory on the right
    image( opencv.image(), 0, ManagerWindowFrameHeight );

    if (!PointsExistFlag) {
        return;
    }

    PImage captureImage = opencv.image();
    PImage maskImage = createDistortedImage(captureImage);
    opencv.copy(maskImage);
    image( opencv.image(), ManagerWindowFrameWidth, ManagerWindowFrameHeight );

    opencv.convert(OpenCV.GRAY);
    opencv.threshold(32);
    image( opencv.image(), 0, ManagerWindowFrameHeight * 2);

    Blob[] blobs = opencv.blobs( 1200, ManagerWindowFrameWidth * ManagerWindowFrameHeight/2, 5,
                                 false, OpenCV.MAX_VERTICES*4 );
    Point[] blobtops = blobTops(blobs);
    displayBlobs(blobs, 0, ManagerWindowFrameHeight*2);
    for (int i=0; i<blobtops.length; ++i) {
        Point p = blobtops[i];
        Boolean nearByFound = false;
        for (int j=0; j<shadows.size(); ++j) {
            Shadow s = (Shadow)shadows.get(j);
            if (s.isNearBy(p.x, p.y)) {
                s.update(p.x, p.y);
                nearByFound = true;
                s.displayVoice();
            }
        }
        if (!nearByFound) {
            Shadow s = new Shadow(p.x, p.y, this);
            shadows.add(s);
        }
    }

    /*
      Display the result.
     */
    //    ap.image( opencv.image(), 0, 0);
}
