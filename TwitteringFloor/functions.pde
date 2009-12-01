void updateShadowsByBlobtops(Point[] blobtops)
{
    for (int i=shadows.size()-1; i>=0; --i) {
        Shadow s = (Shadow)shadows.get(i);
        if (s.isDisappeared()) {
            shadows.remove(i);
            break;
        } else if (s.isGetLost()) {
            s.startDisappear();
        }
        // moves called in each frames
        s.update();
        // flag for location-updated
        s.updated = false;
    }

    for (int i=0; i<blobtops.length; ++i) {
        Boolean found = false;
        Point p = blobtops[i];
        for (int j=0; j<shadows.size(); ++j) {
            Shadow s = (Shadow)shadows.get(j);
            if (s.updated)
                continue;
            if (s.isNearBy(p)) {
                found = true;
                s.updated = true;
                s.updatePoint(p); // does not move
                break;
            }
        }
        if (!found) {
            println("Create new shadow!");
            Shadow s = new Shadow(p.x, p.y, ap);
            if (s != null) {
                shadows.add(s);
            } else {
                println("Shadow constructor failed");
            }
        }
    }
}



/*
void displayShadowsManageWindow(Point[] blobtops, ArrayList shadows, PApplet ap) {
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
}
*/
void displayAllCorners() {
    for (int i=0; i < corners.size(); i++) {
        displayPoint((Point)corners.get(i));
    }
}

void displayPoint(Point p) {
    fill(204, 102, 0);
    ellipse(p.x, p.y, 10, 10);
}

Point [] blobTops(Blob[] blobs) {
    Point[] points = new Point[blobs.length];
    for(int i=0; i<blobs.length; ++i) {
        Blob blob = blobs[i];
        int xsum = 0;
        Point top = new Point();
        top.y = ManagerWindowFrameHeight;
        for(int j=0; j<blob.points.length; ++j) {
            if (top.y > blob.points[j].y) {
                top = blob.points[j];
            }
            xsum += blob.points[j].x;
        }
        top.x = xsum / blob.points.length;
        points[i] = top;
    }
    return points;
}

void displayBlobs(Blob[] blobs, int offsetX, int offsetY) {
    for (int i=0; i<blobs.length; ++i) {
        Blob blob = blobs[i];
        fill(255, 0, 0);
        beginShape();
        Point top = new Point();
        top.y = ManagerWindowFrameHeight; // initial value to be updated
        int xsum = 0;
        for( int j=0; j<blob.points.length; j++ ) {
            vertex( blob.points[j].x + 0, blob.points[j].y + ManagerWindowFrameHeight * 2);
            if (top.y > blob.points[j].y) {
                top = blob.points[j];
            }
            xsum += blob.points[j].x;
        }
        top.x = xsum / blob.points.length;
        endShape(CLOSE);
        fill(0, 255, 0);
        ellipse(top.x + offsetX, top.y + offsetY, 5, 5);
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

