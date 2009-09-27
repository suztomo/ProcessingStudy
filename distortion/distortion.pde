/*
import twitter4j.org.json.*;
import twitter4j.*;
import twitter4j.http.*;
import twitter4j.examples.*;
*/
import hypermedia.video.*;
import processing.video.*;

OpenCV opencv;

float scl = 1;

int windowWidth = int(1280 / scl);
int windowHeight = int(800 / scl);//windowWidth / 4 * 3;

int captureWidth = windowWidth / 1;
int captureHeight = windowHeight / 1;

int frameRate = 10;
float disappearSeconds = 1.0;
int BlobEntryHistoryThrethold = (int)(frameRate * (float)disappearSeconds);
int BlobEntryNearByThrethold = int (0.01 * windowWidth * windowWidth);
int BlobEntryRadius = 30;
int historyCount = 0;

BlobHistory blobHistory;
int BlobEntryIdCount = 0;
PFont font;

//Twitter twitter;

    //メッセージ
java.util.List statuses;


int minBlob = int(0.0005 * windowWidth * windowWidth);
int maxBlob = int(0.03 * windowWidth * windowWidth);


Point newCorners[];
int newCornersSize = 0;
Point origin;
float a,b,c,d;
float diver;
int minY = captureHeight, maxY = 0, minX = captureWidth, maxX = 0;

int showDistortedImage = 0;




void mouseClicked() {
  if (newCornersSize >= 3)
    return;
  newCorners[newCornersSize] = new Point(pmouseX - captureWidth, pmouseY);
  newCornersSize++;
  if (newCornersSize == 3) {
    /*
      For all points in the S which includes the four points,
      get the value (0.0 to 1.0) of the two components.
    */
    Point vx = new Point();
    Point vy = new Point();
    origin = newCorners[0];
    vx.x = newCorners[1].x - origin.x;
    vx.y = newCorners[1].y - origin.y;
    vy.x = newCorners[2].x - origin.x;
    vy.y = newCorners[2].y - origin.y;

    a = vx.x; b = vy.x; c = vx.y; d  = vy.y;
    diver = a * d - b * c;
    if (diver == 0) {
      stop(); 
      println("Div is zero.");
    }
    for (int i=0; i<newCorners.length; i++) {
      if (minY > newCorners[i].y) {
        minY = newCorners[i].y;
      }
      if (maxY < newCorners[i].y) {
        maxY = newCorners[i].y;
      }
      if (minX > newCorners[i].x) {
        minX = newCorners[i].x;
      }
      if (maxX < newCorners[i].x) {
        maxX = newCorners[i].x;
      }
    }
  
    if (minY == captureHeight) {
      println("click point is out of range");
    }

    showDistortedImage = 1;
    historyCount = 0;
  }
}

void setup() {
  newCorners = new Point[3];

  size( windowWidth, windowHeight );

  frameRate(frameRate);

//  frame.setAlwaysOnTop(true); 

  println(Capture.list());

  // open video stream
  opencv = new OpenCV( this );

  opencv.capture( captureWidth, captureHeight, 2);

  PFont f= createFont("Osaka", 20);
  textFont(f);

  blobHistory = new BlobHistory();
/*
  try { 
  twitter = new Twitter("Univ_of_Tokyo","testpass");
  java.util.List sss = twitter.getFriendsStatuses();
  
  statuses = sss;
  } catch(Exception e) {
    println("error");
    println(e.getMessage()); 
  }
*/
}

float markerSpeed = 0.2;
int markerRadius = 30;

class Marker {
  Point p;
  String message;
  Marker(Point initp, String s) {
    p = initp;
    message = s;
    drawSelf();
  }
  public void moveTo(Point newp) {
    move((newp.x - p.x) * markerSpeed, (newp.y - p.y) * markerSpeed);
    this.drawSelf();
  }
  private void move(float speedX, float speedY) {
    p.x += int(speedX);
    p.y += int(speedY);
  }
  
  private void drawSelf() {
    fill(0, 0, 0);
    ellipse(p.x, p.y, markerRadius, markerRadius);

    fill(0, 102, 153);
    text(message, p.x, p.y);
/*
    User  s = (User)statuses.get(int(message)%10);
    println(s);
    text(s.getStatusText());*/
  }
}

class BlobEntry {
  int id;
  int count;
  int updatedCount;
  Point p;
  Marker m;
  BlobEntry(int count, Point pp) {
    count = count;
    p = pp;
    updatedCount=0;
    id = ++BlobEntryIdCount;
    m = null;
  }
  boolean isOld(int nowCount) {
    return (nowCount - count) >  BlobEntryHistoryThrethold;
  }
  boolean isNearBy(Point pp) {
    return pow(p.x - pp.x, 2) + pow(p.y - pp.y, 2) < BlobEntryNearByThrethold;
  }
  void drawPoint() {
    if (updatedCount < 3) {
      // Avoid noise.
      return;
    }
    if (m != null) {
      m.moveTo(p);
    } else {
      m = new Marker(p, "" + id); 
    }
  }
  void updatePoint(Point p) {
    this.p = p;
    this.updatedCount++;
    this.count = historyCount;
  }
}

class BlobHistory {
  ArrayList history;
  BlobHistory() {
    history = new ArrayList();
  }
  void put(BlobEntry e) {
    history.add(e);
  }
  void removeOldEntries() {
    for (int i=0; i<history.size(); ++i) {
      BlobEntry e = (BlobEntry)history.get(i);
      if (e.isOld(historyCount)) {
        history.remove(i);
      }
    }
  }
  ArrayList entries() {
    return history;
  }
  boolean updatePointIfNearBy(Point p) {
    boolean isNew = true;
    for (int i=0; i<history.size(); ++i) {
      BlobEntry e = (BlobEntry)history.get(i);
      if (e.isNearBy(p)) {
        e.updatePoint(p);
        isNew = false;
        break;
      }
    }
    return !isNew;
  }
  void updateBlobs(Blob[] blobs) {
    for (int i=0; i<blobs.length; ++i) {
      Point p = blobs[i].centroid;
      if (! updatePointIfNearBy(p)) {
        // No previous points near by, that is, new point.
        this.put(new BlobEntry(historyCount, p));
      }
    }
  }
}

PImage createDistortedImageInterp(PImage beforeImage) {
  PImage distortedImage = new PImage(captureWidth, captureHeight);
  int beforeX = 0, beforeY = 0;
  int beforeColor =0;
  for (int h=minY; h < maxY; h++) {
    for (int w=minX; w < maxX; w++) {
      // Solves the matrix
      float x, y;
      int relativeX = w - origin.x;
      int relativeY = h - origin.y;
      x = relativeX * d - relativeY * b;
      y = - relativeX * c + relativeY * a;
      x /= diver;
      y /= diver;
      /* 
        If the value  < 0, do nothing 
      */
      if (x >= 0.0 && x < 1.0 && y >= 0.0 && y < 1.0) {
        int new_x, new_y;
        /*
          (the new value_x * Width, the new value_y * Height.)
        */
        new_x = int(captureWidth * x);
        new_y = int(captureHeight * y);
        //println(h+ " " +w);
        int cl = beforeImage.pixels[h * captureWidth + w];
        //    Consider appropriate interpolation.
        int interpColor = beforeColor;
        int diffY = new_y - beforeY;
        if (diffY == 0) {
          for (int interpX = beforeX + 1; interpX < new_x; interpX++) {
            distortedImage.pixels[new_y * captureWidth + interpX] = interpColor;
          }
        }
        if (diffY > 0) {
          for (int interpY = beforeY + 1; interpY < new_y; interpY++) {
            for (int interpX = 0; interpX < captureWidth; interpX++) {
              int beforeColorAbove = distortedImage.pixels[beforeY * captureWidth + interpX];
              distortedImage.pixels[interpY * captureWidth + interpX] = beforeColorAbove;
            }
          }
        }
        distortedImage.pixels[new_y * captureWidth + new_x] = cl;
        beforeX = new_x;
        beforeY = new_y;
        beforeColor = cl;
      }
    } 
  }
  int dirsX[] = {1, 0, -1, 0};
  int dirsY[] = {0, -1, 0, 1}; 
  for (int interpY = 0; interpY < captureHeight; interpY++) {
    for (int interpX = 0; interpX < captureWidth; interpX++) {
      int tc = distortedImage.pixels[interpY * captureWidth + interpX];
      if (tc == 0) {
        int colorSum = 0;
        int nonBlackCount = 0;
        for (int i=0; i < dirsX.length; i++) {
          int xx = interpX + dirsX[i];
          int yy = interpY + dirsY[i];
          if (xx >= 0 && xx < captureWidth && yy >= 0 && yy < captureHeight) {
            int cc = distortedImage.pixels[yy * captureWidth + xx];
            if (cc != 0) {
              colorSum += distortedImage.pixels[interpY * captureWidth + interpX];
              nonBlackCount += 1;
              break;
            }
          }
        }
        if (nonBlackCount > 0) {
          distortedImage.pixels[interpY * captureWidth + interpX] = colorSum / nonBlackCount;
        } else {
           distortedImage.pixels[interpY * captureWidth + interpX] = color(255,255,255);
        }
      }
    }
  } 

  return distortedImage;
}


PImage createDistortedImage(PImage beforeImage) {
  PImage distortedImage = new PImage(captureWidth, captureHeight);
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
      x /= diver;
      y /= diver;
      /* 
        If the value  < 0, do nothing 
      */
      if (x >= 0.0 && x < 1.0 && y >= 0.0 && y < 1.0) {
        int new_x, new_y;
        /*
          (the new value_x * Width, the new value_y * Height.)
        */
        new_x = int(captureWidth * x);
        new_y = int(captureHeight * y);
        //println(h+ " " +w);
        int cl = beforeImage.pixels[h * captureWidth + w];
        //    Consider appropriate interpolation.
        distortedImage.pixels[new_y * captureWidth + new_x] = cl;
      }
    } 
  }
  return distortedImage;
}

void draw() {
  background(255, 255, 255);
  opencv.read();           // grab frame from camera
  // display the image
  if (showDistortedImage == 0) {
    image( opencv.image(), 0, 0 );
    for (int i=0; i< newCornersSize; i++) {
      fill(255, 0, 0);
      ellipse(newCorners[i].x + captureWidth, newCorners[i].y, 5, 5);
    }
    return;
  }
  //  opencv.convert(OpenCV.GRAY);

  PImage beforeImage = opencv.image();

  /* get the vectors of AB and AD */
  PImage distortedImage = createDistortedImage(beforeImage);
//  image(distortedImage, 0, 0);
//  PImage distortedImageInterp = createDistortedImageInterp(beforeImage);
//  image(distortedImageInterp, 0, 0);
  opencv.copy(distortedImage);
  opencv.blur( OpenCV.BLUR, 5 );
//  image( opencv.image(), 0, 0);

  /* Only memorize the image when it is the first drawing */
  if (historyCount == 0) {
    opencv.remember(OpenCV.BUFFER);
    historyCount = 1;
    return;
  }
  opencv.absDiff();                            // make the difference between the current image and the image in memory
//  image(opencv.image(), 0, 0);
//  image(opencv.image(OpenCV.MEMORY), captureWidth, captureHeight);
  opencv.threshold(10);    // set black & white threshold 

  //image( opencv.image(), 0, 0);

  // find blobs
  Blob[] blobs  = opencv.blobs( minBlob, width*height/2, 5, true, OpenCV.MAX_VERTICES*4 );
  blobHistory.updateBlobs(blobs);

  ArrayList bhe = blobHistory.entries();

  for (int i=0; i<bhe.size(); ++i) {
    BlobEntry be = (BlobEntry)bhe.get(i);
    be.drawPoint();
  }

  blobHistory.removeOldEntries();

  //opencv.remember();  // store the actual image in memory
  historyCount++;

  //    delay(100);
}

void keyPressed(){
//  opencv.remember();
  if (key == CODED) {
    if (keyCode == UP) {
      newCornersSize = 0;
      showDistortedImage = 0;
      
    }
  }
}

