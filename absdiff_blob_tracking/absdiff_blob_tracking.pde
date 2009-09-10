import hypermedia.video.*;

OpenCV opencv;

int frameRate = 20;
float disappearSeconds = 1.0;
int BlobEntryHistoryThrethold = (int)(frameRate * (float)disappearSeconds);
int BlobEntryNearByThrethold = 300;
int minBlob = 200;
int maxBlob = 700;
int BlobEntryRadius = 30;
int historyCount = 0;

BlobHistory blobHistory;
int BlobEntryIdCount = 0;
PFont font;

void setup() {

    size( 320, 240 );

    frameRate(40);

    // open video stream
    opencv = new OpenCV( this );
    opencv.capture( 160, 120 );
    
    font = loadFont("Serif-30.vlw"); 
    textFont(font); 

    blobHistory = new BlobHistory();
}


class BlobEntry {
  int id;
  int count;
  int updatedCount;
  Point p;
  BlobEntry(int count, Point pp) {
    count = count;
    p = pp;
    updatedCount=0;
    id = ++BlobEntryIdCount;
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
    fill(0, 0, 0);
    ellipse(p.x, p.y, BlobEntryRadius, BlobEntryRadius);

    fill(0, 102, 153);
    text("" + id, p.x, p.y); 
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

    /* Only memorize the image when it is the first drawing */
    if (historyCount == 0) {
      opencv.remember();
      historyCount = 1;
      return;
    }
    opencv.absDiff();                            // make the difference between the current image and the image in memory

    image( opencv.image(), 160, 0 );
    opencv.threshold(20);    // set black & white threshold 

    image( opencv.image(), 160, 120 );
    // find blobs
    Blob[] blobs  = opencv.blobs( minBlob, width*height/2, 5, true, OpenCV.MAX_VERTICES*4 );

    // draw blob results
    println(blobs.length);
    
    blobHistory.updateBlobs(blobs);

    ArrayList bhe = blobHistory.entries();
    for (int i=0; i<bhe.size(); ++i) {
      BlobEntry be = (BlobEntry)bhe.get(i);
      be.drawPoint();
    }
    
    blobHistory.removeOldEntries();
    
    opencv.remember();  // store the actual image in memory
    historyCount++;

//    delay(100);
}

