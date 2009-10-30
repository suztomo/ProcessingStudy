import hypermedia.video.*;

OpenCV opencv;

/*

 */
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

void setup() {

    size( ManagerWindowWidth, ManagerWindowHeight );
    opencv = new OpenCV( this );
    opencv.capture( ManagerWindowFrameWidth, ManagerWindowFrameHeight );

    opencv.read();     // grab frame from camera
    opencv.remember();  // store the actual image in memory
    corners = new Point[3];
    fr = new DebugFrame();
    BufferedReader reader = null;
    reader = createReader(PointsFileName);
    PFont font = createFont("Osaka", 20);
    textFont(font);

    String lineX, lineY;
    while(true) {
        try {
            lineX = reader.readLine();
            lineY = reader.readLine();
            int x = int(lineX);
            int y = int(lineY);
            corners[cornersSize++] = new Point(x, y);
            if (cornersSize == 3) {
                println("Points found from file");
                PointsExistFlag = true;
                calculateVecs();
                //                calculateDet();
                break;
            }
        } catch (Exception e) {
            println("No file named " + PointsFileName);
            break;
        }
    }
}

void writePointFile() {
    PrintWriter writer = null;
    writer = createWriter(PointsFileName);
    for (int i=0; i<3; ++i) {
        writer.println(str(corners[i].x));
        writer.println(str(corners[i].y));
    }
    writer.flush();
    writer.close();
    println(PointsFileName + " was created.");
}

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

void mouseClicked() {
    if (cornersSize >= 3){ return; }
    corners[cornersSize] = new Point(mouseX, mouseY);
    cornersSize++;
    if (cornersSize == 3) {
        /*
          For all points in the S which includes the four points,
          get the value (0.0 to 1.0) of the two components.
        */
        // calculateDet();
        calculateVecs();
        writePointFile();
    }
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
    println(blobs.length);
    for (int i=0; i<blobs.length; ++i) {
        Blob blob = blobs[i];
        fill(255, 0, 0);
        beginShape();
        for( int j=0; j<blob.points.length; j++ ) {
            vertex( blob.points[j].x + 0, blob.points[j].y + ManagerWindowFrameHeight * 2);
        }
        endShape(CLOSE);


        /*
        strole(255,255, 0);
        rect(blob.rectangle.x, blob.rectangle.y, blob.rectangle.width, blob.rectangle.height);
        */
    }


    ap.image( opencv.image(), 0, 0);

}

void keyPressed() {
    opencv.remember();  // store the actual image in memory
    cornersSize = 0;
}

void displayAllPoints() {
    for (int i=0; i < cornersSize; i++) {
        displayPoint(corners[i]);
    }
    if (cornersSize == 0)
        corners = new Point[3];
}

void displayPoint(Point p) {
    fill(204, 102, 0);
    ellipse(p.x, p.y, 10, 10);
}



public class DebugFrame extends Frame{
    public DebugFrame(){
        setBounds(0,0, DisplayWindowWidth, DisplayWindowHeight*2);
        ap = new DebugApplet();
        add(ap);
        ap.init();
        show();
    }
}

public class DebugApplet extends PApplet{
    public void setup(){
        size(DisplayWindowWidth*2, DisplayWindowHeight*2);
        PFont font = createFont("Osaka", 20);
        textFont(font);
    }
    public void draw(){
        text("風船多すぎ（´・ω・｀）", 0, 300);
    }
}
