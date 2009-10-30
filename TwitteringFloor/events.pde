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

void keyPressed() {
    opencv.remember();  // store the actual image in memory
    cornersSize = 0;
}
