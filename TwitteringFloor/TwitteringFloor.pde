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

Point[] corners;
int cornersSize = 0;

Point origin;
Point OA, OB;



Boolean pointInFrame(Point p) {
    if (p.x < 0 || p.x >= ManagerWindowFrameWidth ||
        p.y < 0 || p.y >= ManagerWindowFrameHeight) {
        return false;
    }
    return true;
}

void calculateVecs() {
    for (int i=0; i<cornersSize; ++i) {
        if (!pointInFrame(corners[i])) {
            println("Wrong point found!");
            println(corners[i]);
        }
    }
    OA = new Point();
    OB = new Point();

    origin = corners[0];
    OA.x = corners[1].x - origin.x;
    OA.y = corners[1].y - origin.y;
    OB.x = corners[2].x - origin.x;
    OB.y = corners[2].y - origin.y;
}



PImage createDistortedImage(PImage beforeImage) {
  PImage distortedImage = new PImage(ManagerWindowFrameWidth, ManagerWindowFrameHeight);
  for (int y=0; y<ManagerWindowFrameHeight; ++y) {
      for (int x = 0; x < ManagerWindowFrameWidth; ++x) {
          int cl;
          float xt = ((float)x / ManagerWindowFrameWidth);
          float yt = ((float)y / ManagerWindowFrameHeight);
          int bx = int(origin.x + OA.x * xt + OB.x * yt);
          int by = int(origin.y + OA.y * xt + OB.y * yt);
          cl = beforeImage.pixels[by * ManagerWindowFrameWidth + bx];
          distortedImage.pixels[y * ManagerWindowFrameWidth + x] = cl;
      }
  }
  return distortedImage;
}

void draw() {

    opencv.read();                               // grab frame from camera
    image( opencv.image(), 0, 0);                // show the original image

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
    image( opencv.image(), 0, ManagerWindowFrameHeight * 2);
    opencv.threshold(32);

    Blob[] blobs = opencv.blobs( 30, ManagerWindowFrameWidth * ManagerWindowFrameHeight/2, 5,
                                 false, OpenCV.MAX_VERTICES*4 );
    displayBlobs(blobs);

    /*
      Display the result.
     */
    ap.image( opencv.image(), 0, 0);
}
