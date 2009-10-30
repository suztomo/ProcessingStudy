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


void displayBlobs(Blob[] blobs) {
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
        top.y += ManagerWindowFrameHeight*2;
        fill(0, 255, 0);
        ellipse(top.x, top.y, 5, 5);
        /*
        strole(255,255, 0);
        rect(blob.rectangle.x, blob.rectangle.y, blob.rectangle.width, blob.rectangle.height);
        */
    }
}
