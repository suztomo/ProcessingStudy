import hypermedia.video.*;

OpenCV opencv;

int windowWidth = 1280;
int windowHeight = 800;//windowWidth / 4 * 3;

int frameRate = 20;
float disappearSeconds = 1.0;
int BlobEntryHistoryThrethold = (int)(frameRate * (float)disappearSeconds);
int BlobEntryNearByThrethold = int (0.003 * windowWidth * windowWidth);
int BlobEntryRadius = 30;
int historyCount = 0;

BlobHistory blobHistory;
int BlobEntryIdCount = 0;
PFont font;


int minBlob = int(0.002 * windowWidth * windowWidth);
int maxBlob = int(0.03 * windowWidth * windowWidth);

void setup() {

  size( windowWidth, windowHeight );

  frameRate(frameRate);

  frame.setAlwaysOnTop(true); 

  // open video stream
  opencv = new OpenCV( this );
  opencv.capture( windowWidth / 2, windowHeight / 2);

  font = loadFont("Serif-30.vlw"); 
  textFont(font);

  blobHistory = new BlobHistory();
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

void draw() {
  background(192);
  opencv.read();           // grab frame from camera
  // display the image
  image( opencv.image(), 0, 0 );
  opencv.convert(OpenCV.GRAY);

  /* Only memorize the image when it is the first drawing */
  if (historyCount == 0) {
    opencv.remember();
    historyCount = 1;
    return;
  }
  opencv.absDiff();                            // make the difference between the current image and the image in memory

  image( opencv.image(), windowWidth / 2, 0 );
  opencv.threshold(50);    // set black & white threshold 

  image( opencv.image(), windowWidth / 2, windowHeight / 2 );
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


