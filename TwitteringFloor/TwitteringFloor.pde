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
float a, b, c, d;
float det;
int minX = ManagerWindowFrameWidth, maxX = 0;
int minY = ManagerWindowFrameHeight, maxY = 0;


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
                calculateDet();
                break;
            }
        } catch (Exception e) {
            println("No file named " + PointsFileName);
            break;
        }
    }
}

void calculateDet() {
    origin = corners[0];
    a = corners[1].x - origin.x;
    b = corners[2].x - origin.x;
    c = corners[1].y - origin.y;
    d = corners[2].y - origin.y;
    det = a * d - b * c;
    if (det == 0) {
      stop(); 
      println("Div is zero.");
    }
    minX = min(minX, min(corners[0].x, corners[1].x, corners[2].x));
    minY = min(minY, min(corners[0].y, corners[1].y, corners[2].y));
    maxX = max(maxX, max(corners[0].x, corners[1].x, corners[2].x));
    maxY = max(maxY, max(corners[0].y, corners[1].y, corners[2].y));

    PrintWriter writer = null;
    writer = createWriter(PointsFileName);
    for (int i=0; i<3; ++i) {
        writer.println(str(corners[i].x));
        writer.println(str(corners[i].y));
    }
    writer.flush();
    writer.close();
    println(PointsFileName + " was created.");
    PointsExistFlag = true;
    if (minY == ManagerWindowFrameHeight) {
      println("click point is out of range");
    }
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
    calculateDet();
  }
}


PImage createDistortedImage(PImage beforeImage) {
  PImage distortedImage = new PImage(DisplayWindowWidth, DisplayWindowHeight);
  int beforeX = 0, beforeY = 0;
  int beforeColor = 0;
  for (int h=minY; h < maxY; h++) {
    for (int w=minX; w < maxX; w++) {
      // Solves the matrix
      float x, y;
      int relativeX = w - origin.x;
      int relativeY = h - origin.y;
      x = relativeX * d - relativeY * b;
      y = - relativeX * c + relativeY * a;
      x /= det;
      y /= det;
      /* 
        If the value  < 0, do nothing 
      */
      if (x >= 0.0 && x < 1.0 && y >= 0.0 && y < 1.0) {
        int new_x, new_y;
        /*
          (the new value_x * Width, the new value_y * Height.)
        */
        new_x = int(DisplayWindowWidth * x);
        new_y = int(DisplayWindowHeight * y);
        int cl = beforeImage.pixels[h * ManagerWindowFrameWidth + w];
        distortedImage.pixels[new_y * DisplayWindowWidth + new_x] = cl;
      }
    } 
  }
  return distortedImage;
}

void draw() {

    opencv.read();                               // grab frame from camera
    image( opencv.image(), 0, 0);                // show the original image

    // make the difference between the current image and the image in memory
    image(opencv.image(OpenCV.MEMORY), ManagerWindowFrameWidth, 0);
   
    // Caribrated image
    opencv.absDiff();                            
    image( opencv.image(), 0, ManagerWindowFrameHeight );  // display the image in memory on the right
 
    if (!PointsExistFlag) {
        return;
    }

    PImage captureImage = opencv.image();
    PImage maskImage = createDistortedImage(captureImage);
    opencv.copy(maskImage);
    image( opencv.image(), ManagerWindowFrameWidth, ManagerWindowFrameHeight );             // display the result on the bottom right
    ap.image( opencv.image(), 0, 0);
    
}

void keyPressed() {
    opencv.remember();  // store the actual image in memory
    cornersSize = 0;
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
  }
  public void draw(){

  }
}
