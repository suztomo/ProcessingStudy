void displayAllPoints() {
    for (int i=0; i < corners.size(); i++) {
        displayPoint((Point)corners.get(i));
    }
}

void displayPoint(Point p) {
    fill(204, 102, 0);
    ellipse(p.x, p.y, 10, 10);
}


void displayBlobs(Blob[] blobs, int offsetX, int offsetY) {
    for (int i=0; i<blobs.length; ++i) {
        Blob blob = blobs[i];
        fill(255, 0, 0);
        beginShape();
        Point top = new Point();
        top.y = ManagerWindowFrameHeight;
        for( int j=0; j<blob.points.length; j++ ) {
            vertex( blob.points[j].x + 0, blob.points[j].y + ManagerWindowFrameHeight * 2);
            if (top.y > blob.points[j].y) {
                top = blob.points[j];
            }
        }
        endShape(CLOSE);
        top.x += offsetX;
        top.y += offsetY;
        fill(0, 255, 0);
        ellipse(top.x, top.y, 5, 5);
        /*
        strole(255,255, 0);
        rect(blob.rectangle.x, blob.rectangle.y, blob.rectangle.width, blob.rectangle.height);
        */
    }
}

Boolean pointInFrame(Point p) {
    if (p.x < 0 || p.x >= ManagerWindowFrameWidth ||
        p.y < 0 || p.y >= ManagerWindowFrameHeight) {
        return false;
    }
    return true;
}

void calculateVecs() {
    if (corners.size() != 3) {
        println("size of corners is wrong");
    }
    for (int i=0; i<corners.size(); ++i) {
        if (!pointInFrame((Point)corners.get(i))) {
            println("Wrong point found!");
            println((Point)corners.get(i));
        }
    }
    OA = new Point();
    OB = new Point();

    origin = (Point)corners.get(0);
    OA.x = ((Point)corners.get(1)).x - origin.x;
    OA.y = ((Point)corners.get(1)).y - origin.y;
    OB.x = ((Point)corners.get(2)).x - origin.x;
    OB.y = ((Point)corners.get(2)).y - origin.y;
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

void resetPoints() {
    corners = new ArrayList();
    if (ap == null) {
        println("ap is not defined");
    }
}

void createFonts() {
    PFont font = createFont("Osaka", 20);
    textFont(font);
}



